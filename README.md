This is the repository for all my Unraid/Plex scripts.

containercounter.py - Counts your active docker containers and compares it to a total number to notify you when any are missing. Input your # of normally running dockers as the c value and enter a valid Discord webhook. Run on a cron to check your dockers on a regular schedule. 

containercounter2.py - Updated container counter that takes inventory of running containers on first run. Set on cron schedule and it will notify you when a docker has gone down and what docker is down.

SFB.sh - backs up the file specified to the destination specified then removes all but 3 latest backups. WARNING - this will remove most/all files in the destination directory! Use with caution. It is highly recommended to backup to an empty directory.

MFB21D.sh - backs up the multiple files to a single destination then removes all but 3 latest backups. WARNING - this will remove most/all files in the destination directory! Use with caution. It is highly recommended to backup to an empty directory.

MFB2AD.sh - backs up the multiple files to a multiple destinations then removes all but 3 latest backups. WARNING - this will remove most/all files in the destination directories! Use with caution. It is highly recommended to backup to empty directories.
