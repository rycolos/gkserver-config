import yaml, requests, sys
from datetime import datetime

config_path = 'discord.yaml'
#webhooks / webhook1, user / user1

with open(config_path, 'r') as file:
    config_file = yaml.safe_load(file)
url = config_file['webhooks']['webhook1']
username = config_file['user']['user1']

now = datetime.now()
read = sys.stdin.read()

content = f"Cron job completed at {now}\n```{read}```"

data = {
    "content" : content,
    "username" : username
}

result = requests.post(url, json = data)

try:
    result.raise_for_status()
except requests.exceptions.HTTPError as err:
    print(err)