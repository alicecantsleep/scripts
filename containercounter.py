#!/bin/bash
#written by deathbydentures

#Counts your active docker containers and compares it to a total number to notify you when 
#any are missing. Input your # of normally running dockers as the c value and enter a valid 
#Discord webhook. Run on a cron to check your dockers on a regular schedule.

import subprocess
import dhooks
from dhooks import Webhook, Embed

c = 19 #total number of containers that SHOULD be running.
s = subprocess.check_output('docker ps -q | wc -l', shell=True)
a = s.decode('ascii')
r = (c) - int(a)

if int(a) > c:
    print ('All containers running!')
else:
    if int(a) == c:
        print ('All containers running!')
    else:
        print ('WARNING: ', r, ' containers are missing. Please check running Dockers.')
        hook = Webhook('WEBHOOK URL') #Enter a valid Discord webhook URL here.
        embed = Embed(
            description='WARNING: Containers are missing. Please check running Dockers.',
            color=0xff0000, #any hexidecimal color code works here.
            timestamp='now'
            )

        image1 = 'https://i.imgur.com/rdm3W9t.png' #update the thumbnail here.

        embed.set_author(name='Container Counter Error', icon_url=image1)
        embed.add_field(name='Missing Containers', value=r)
        embed.add_field(name='Total Containers', value=c)
        embed.set_footer(text='Ya shit broke, dawg', icon_url=image1)

        embed.set_thumbnail(image1)

        hook.send(embed=embed)
