#!/bin/bash
#Written by alicecantsleep and chatGPT
#Backs up files specified to target directories and removes
#all but newest 3 files. This can be adjusted on line 48.
#WARNING - WILL DELETED ALL FILES IN DESTINATION DIRECTORIES
#HIGHLY recommended to backup to a new directories
#DON'T FORGET THE CONFIG FILE

# Load the configuration
source 'MFB2AD_config.ini'

# Loop through each file in the file_list
for file_data in "${file_list[@]}"; do
    # Parse file and backup directory from file_data
    file=$(echo "$file_data" | awk -F':' '{print $1}')
    backup_dir=$(echo "$file_data" | awk -F':' '{print $2}')

    # Create the backup directory if it doesn't exist
    mkdir -p "$backup_dir"

    # Check if the file exists
    if [ -f "$file" ]; then
        # Create the backup file name with today's date
        backup_file="${backup_dir}/$(date +%Y%m%d)_$(basename "$file")"

        # Copy the file to the backup location
        cp "$file" "$backup_file"

        # Check if the backup was successful
        if [ $? -eq 0 ]; then
            echo "Backup created for $file: $backup_file"
        else
            echo "Backup failed for file: $file"
        fi
    else
        echo "File does not exist: $file"
    fi
done

# Cleanup old backups, keeping only the newest 3 for each file
for file_data in "${file_list[@]}"; do
    # Parse file and backup directory from file_data
    file=$(echo "$file_data" | awk -F':' '{print $1}')
    backup_dir=$(echo "$file_data" | awk -F':' '{print $2}')

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
done

echo "Backup and cleanup completed."
