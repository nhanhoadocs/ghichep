import os
import time
import datetime
from .slack_notify import Slack
from .telegram_notify import Telegram
import logging
from utils import common

logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s', filename='/var/log/backup.log',level=logging.DEBUG, datefmt='%Y-%m-%d %H:%M:%S')

class Backup(object):
    def __init__(self, settings):
        self.settings = settings
        self.db_user_name           = settings["mysql"]["user"]
        self.db_password            = settings["mysql"]["password"]
        self.database               = settings["mysql"]["database"]
        self.tables                 = settings["mysql"]["tables"]
        self.output_startw          = settings["backup"]["backup_file_name"]
        self.backup_folder          = settings["backup"]["backup_folder"]
        self.slack_token            = settings["slack"]["token"]
        self.slack_channel          = settings["slack"]["channel"]
        self.telegram_token         = settings["telegram"]["token"]
        self.telegram_channel       = settings["telegram"]["chat_id"]
        self.is_sync                = settings["sync"]["sync"]
        self.is_delete_file         = settings["delete_old_file"]["delete_old_file"]
        self.is_send_notify_telegram   = settings["telegram"]["send_notify"]
        self.is_send_notify_slack = settings["slack"]["send_notify"]
        self.backup_type            = settings["mysql"]["backup_type"]  

        self.notify_date = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        self.current_date = datetime.datetime.now().strftime('%Y-%m-%d')
        self.current_time = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        self.backup_dir = self.backup_folder + "/" + self.current_date
        self.backup_dir = self.backup_folder + "/" + self.current_date

        

    def backup_database(self):
        backup_dir = self.backup_folder + "/" + self.current_date
        create_backup_dir = "mkdir -p "+ backup_dir
        backup_command = self.get_command_backup(backup_dir)
        
        try:
            os.system(create_backup_dir) 
            os.system(backup_command)
            backup_size = common.check_file_size(backup_dir + "/"+ self.output_startw + "_" + self.current_time +".sql.gz")
            telegram_message = common.render_message_telegram(datetime=self.notify_date, file_size=backup_size, 
                                                                    file_name=self.output_startw + "_" + self.current_time +".sql.gz" )
            slack_message = common.render_message_telegram(datetime=self.notify_date, file_size=backup_size, 
                                                                    file_name=self.output_startw + "_" + self.current_time +".sql.gz" )
            # Delete old folder and sync
            if self.is_delete_file is True:
                common.remove_old_folder(self.settings)
            if self.is_sync is True:
                common.sync_to_ftp(self.settings)
            if self.is_send_notify_telegram is True:
                telegram = Telegram(self.telegram_token, self.telegram_channel, telegram_message)
                telegram.send_message()
            if self.is_send_notify_slack is True:
                slack = Slack(self.slack_token , self.slack_channel, slack_message)
                slack.send_message() 

        except Exception as ex:
            logging.warning("backup " + ex)
    

    def get_command_backup(self, backup_dir):
        if self.backup_type == "database":
            if (self.db_password).strip() != '' and self.db_password is not None:
                backup_command = "mysqldump -u" + self.db_user_name + " -p" + self.db_password + " " + self.database + " 2>/dev/null | gzip > " + backup_dir + "/"+ self.output_startw + "_" + self.current_time +".sql.gz"
            else:
                backup_command = "mysqldump -u" + self.db_user_name + " " + self.database + " 2>/dev/null | gzip > " + backup_dir + "/"+ self.output_startw + "_" + self.current_time +".sql.gz"
        if self.backup_type == "table":
            backup_table = (self.tables).strip().replace(",", "")
            if (self.db_password).strip() != '' and self.db_password is not None:
                backup_command = "mysqldump -u" + self.db_user_name + " -p" + self.db_password + " " + self.database + " " + backup_table + " 2>/dev/null | gzip > " + backup_dir + "/"+ self.output_startw + "_" + self.current_time +".sql.gz"
            else:
                backup_command = "mysqldump -u" + self.db_user_name + " " + self.database + " " + backup_table + " 2>/dev/null | gzip > " + backup_dir + "/"+ self.output_startw + "_" + self.current_time +".sql.gz"    
        if self.backup_type == "all":
            if (self.db_password).strip() != '' and self.db_password is not None:
                backup_command = "mysqldump -u" + self.db_user_name + " -p" + self.db_password + " " + "--all-databases" + " 2>/dev/null | gzip > " + backup_dir + "/"+ self.output_startw + "_" + self.current_time +".sql.gz"
            else:
                backup_command = "mysqldump -u" + self.db_user_name + " " + "--all-databases" + " 2>/dev/null | gzip > " + backup_dir + "/"+ self.output_startw + "_" + self.current_time +".sql.gz"    

        return backup_command