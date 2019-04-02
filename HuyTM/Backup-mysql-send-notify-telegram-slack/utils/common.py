import os
import json
import logging
import time
import shutil

logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s', filename='/var/log/backup.log',level=logging.DEBUG, datefmt='%Y-%m-%d %H:%M:%S')

def sync_to_ftp(settings):
    try:
        command = "rsync -arv " + settings["backup"]["backup_folder"] + " root@" + settings["sync"]["ftp_server"] + ":" + settings["sync"]["remote_sync_path"]
        os.system(command)
    except Exception as ex:
        logging.warning(" Không thể sync tới FTP server " + ex)

def convert_bytes(num):
    """
    this function will convert bytes to MB.... GB... etc
    """
    for x in ['bytes', 'KB', 'MB', 'GB', 'TB']:
        if num < 1024.0:
            return "%3.1f %s" % (num, x)
        num /= 1024.0

def render_message_telegram(datetime, file_size, file_name):
    string = "``` [Backup Database]\n" + "Time: " + datetime + "\n" "Backup file name: " + file_name + "\n" "Backup file size: " + file_size + "\n"  + "```"
    return string

def render_message_slack(datetime, file_size, file_name):
    string = "``` [Backup Database]\n" + "Time: " + datetime + "\n" "Backup file name: " + file_name + "\n" "Backup file size: " + file_size + "\n"  + "```"
    return string

def remove_old_folder(settings):
    now = time.time()
    numdays = 86400 * settings["delete_old_file"]["remove_days"]
    folder = settings["backup"]["backup_folder"]

    try:
        for f in os.listdir(folder):
            f = os.path.join(folder, f)
            if os.stat(f).st_mtime < now - numdays:
               shutil.rmtree(f)
    except Exception as ex:    
        logging.warning(" Cannot delete old folder " + ex)

def check_file_size(file_path):
    file_info = os.stat(file_path).st_size
    return convert_bytes(file_info)       