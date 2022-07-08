import requests
import json
import pprint
import os


class SlackClient:
    def __init__(self):
        env = os.environ.get("TTW_ENV")
        self.slack_token = "xoxb-2852756709600-2911375163009-ozDDY2ZV5FZmKFMOSDzSR4Uu"
        self.default_channel = "C038UA8NLGN"
        if env == "prod":
            self.default_channel = "C02T4DGCZLG"

    def post_message(self, text, channel=None, blocks=None):
        headers = {
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": f"Bearer {self.slack_token}",
        }
        if not channel:
            channel = self.default_channel
        body = {"token": self.slack_token, "text": text, "channel": channel}
        print(self.slack_token)
        return requests.post(
            "https://slack.com/api/chat.postMessage",
            headers=headers,
            json=body,
        ).json()
        """
		data=json.dumps(
			{
				"token": self.slack_token,
				"channel": channel,
				"text": text,
				#'icon_url': slack_icon_url,
				#'username': slack_user_name,
				# "blocks": json.dumps(blocks) if blocks else None,
			}
		),
		"""


if __name__ == "__main__":
    sc = SlackClient()
    message = "How are you today?"
    channel = "C02T4DGCZLG"
    pprint.pprint(sc.post_message(message, channel=channel))
