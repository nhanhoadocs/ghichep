import os
import json
from app.backup import Backup
import logging

app_path = os.path.dirname(os.path.abspath(__file__))
logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s', filename='/var/log/backup.log',level=logging.DEBUG, datefmt='%Y-%m-%d %H:%M:%S')

with open(app_path + '/settings/settings.json') as data:
    settings = json.load(data)

def run_backup(settings):
    try:
        backup = Backup(settings)
        backup.backup_database()
    except Exception as ex:
        logging.warning("Cannot read setting file" + ex)

run_backup(settings)