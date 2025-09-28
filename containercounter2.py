#!/usr/bin/env python3
# container_watcher.py — monitors Docker containers and alerts on failure

import subprocess
import os
from dhooks import Webhook, Embed

# Replace with your own Discord webhook URL
WEBHOOK_URL = 'https://your.webhook.url/here'
hook = Webhook(WEBHOOK_URL)
ICON_URL = 'https://your.image.url/here.png'

# Get currently running container names
def get_running_containers():
    result = subprocess.check_output("docker ps --format '{{.Names}}'", shell=True)
    return set(result.decode('utf-8').strip().split('\n')) if result else set()

# Load known containers from app.list
def load_known_containers(filepath):
    if not os.path.exists(filepath):
        current = get_running_containers()
        with open(filepath, 'w') as f:
            f.write('\n'.join(name.title() for name in current))
        print("Initialized app.list with current containers.")
        return set(name.title() for name in current)
    with open(filepath, 'r') as f:
        return set(line.strip().title() for line in f if line.strip())

# Notify when containers are missing
def notify_missing(missing, total_expected, total_running):
    missing_titles = [name.title() for name in missing]

    if total_running == 0:
        description = "🚨 All containers are offline!\nThe system is down."
        embed = Embed(description=description, color=0x8B0000, timestamp='now')
        embed.set_author(name='Container Failure', icon_url=ICON_URL)
        embed.set_footer(text='Alert triggered.', icon_url=ICON_URL)
        embed.set_thumbnail(ICON_URL)
        hook.send(embed=embed)
        return

    if len(missing) == 1:
        description = f"⚠️ {missing_titles[0]} is down!\nPlease investigate."
    else:
        description = f"⚠️ Multiple containers are down:\n{', '.join(missing_titles)}\nPlease investigate."

    embed = Embed(description=description, color=0xff0000, timestamp='now')
    embed.set_author(name='Container Alert', icon_url=ICON_URL)
    embed.add_field(name='Expected:', value=str(total_expected), inline=True)
    embed.add_field(name='Running:', value=str(total_running), inline=True)
    embed.add_field(name='Down:', value=', '.join(missing_titles), inline=False)
    embed.set_footer(text='Alert triggered.', icon_url=ICON_URL)
    embed.set_thumbnail(ICON_URL)
    hook.send(embed=embed)

# Main logic
APP_LIST = 'app.list'
known_containers = load_known_containers(APP_LIST)
current_containers = set(name.title() for name in get_running_containers())

missing = known_containers - current_containers

if not missing:
    print("All containers accounted for.")
else:
    print(f"WARNING: Missing containers: {', '.join(missing)}")
    notify_missing(missing, len(known_containers), len(current_containers))
