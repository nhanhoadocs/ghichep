from slackclient import SlackClient
import logging
logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s', filename='/var/log/backup.log',level=logging.DEBUG, datefmt='%Y-%m-%d %H:%M:%S')

class Slack(object):
    def __init__(self, token, channel, message):
        self.slack_bot = SlackClient(token)
        self.channel = channel
        self.message = message

    def send_message(self):
        try:
            self.slack_bot.api_call("chat.postMessage", channel=self.channel, text=self.message)
        except Exception as ex:
            logging.warning("slack_notify " + ex)
