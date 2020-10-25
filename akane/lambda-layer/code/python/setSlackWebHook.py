import slackweb

def set_slack_webhook(web_hook_url, channel, text):
    slack = slackweb.Slack(url=web_hook_url)
    slack.notify(text=text, channel=channel)