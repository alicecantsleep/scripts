#!/bin/bash
#Written by alicecantsleep and chatGPT
#Command: sh /sfb.sh <file> <backup_dir>
#Backs up file specified to directory specified and removes
#all but newest 3 files. This can be adjusted on line 41.
#WARNING - WILL DELETED ALL FILES IN DESTINATION DIRECTORY
#HIGHLY recommended to backup to a new directory

file=$1
backup_dir=$2

# Create the backup directory if it doesn't exist
mkdir -p "$backup_dir"

if [ -z "$file" ] || [ -z "$backup_dir" ]; then
    echo "Usage: SFB.sh <file> <backup_dir>"
    exit 1
fi

if [ ! -f "$file" ]; then
    echo "File does not exist: $file"
    exit 1
fi

# Create the backup file name with today's date
backup_file="${backup_dir}/$(date +%Y%m%d)_$(basename "$file")"

# Copy the file to the backup location
cp "$file" "$backup_file"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup created for $file: $backup_file"
else
    echo "Backup failed for file: $file"
    exit 1
fi

# Cleanup old backups, keeping only the newest 3
backup_files=("$backup_dir"/*)
num_backups=${#backup_files[@]}
num_backups_to_keep=3

if [ "$num_backups" -gt "$num_backups_to_keep" ]; then
    files_to_delete=("${backup_files[@]:num_backups_to_keep}")

    # Delete older backup files
    for file in "${files_to_delete[@]}"; do
        rm "$file"
        echo "Deleted backup for $file: $file"
    done
fi

echo "Backup and cleanup completed."
