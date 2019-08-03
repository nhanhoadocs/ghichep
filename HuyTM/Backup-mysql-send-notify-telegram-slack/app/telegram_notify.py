import telegram
import logging
logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s', filename='/var/log/backup.log',level=logging.DEBUG, datefmt='%Y-%m-%d %H:%M:%S')

class Telegram(object):
        def __init__(self, telegram_token, chat_id, message):
            self.bot_telegram = telegram.Bot(telegram_token)
            self.chat_id = chat_id
            self.message = message

        def send_message(self):
            try:
                self.bot_telegram.send_message(chat_id=self.chat_id, text=self.message, parse_mode='Markdown')
            except Exception as ex:
                logging.warning("telegram " + ex)
