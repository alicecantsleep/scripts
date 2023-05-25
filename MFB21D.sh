#!/bin/bash
#Written by alicecantsleep and chatGPT
#Backs up files specified to target directory and removes
#all but newest 3 files. This can be adjusted on line 40.
#WARNING - WILL DELETED ALL FILES IN DESTINATION DIRECTORIES
#HIGHLY recommended to backup to a new directories
#DON'T FORGET THE CONFIG FILE

# Load the configuration
source 'MFB21D_config.ini'

# Create the backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Loop through each file in the file_list
for file_path in "${file_list[@]}"; do
    # Check if the file exists
    if [ -f "$file_path" ]; then
        # Create the backup directory if it doesn't exist
        mkdir -p "$backup_dir"
        # Create the backup file name with today's date
        backup_file="${backup_dir}/$(date +%Y%m%d)_$(basename "$file_path")"

        # Copy the file to the backup location
        cp "$file_path" "$backup_file"

        # Check if the backup was successful
        if [ $? -eq 0 ]; then
            echo "Backup created: $backup_file"
        else
            echo "Backup failed for file: $file_path"
        fi
    else
        echo "File does not exist: $file_path"
    fi
done

# Cleanup old backups, keeping only the newest 3
backup_files=("$backup_dir"/*)
num_backups=${#backup_files[@]}
num_backups_to_keep=3

if [ "$num_backups" -gt "$num_backups_to_keep" ]; then
    files_to_delete=("${backup_files[@]:num_backups_to_keep}")

    # Delete older backup files
    for file in "${files_to_delete[@]}"; do
        rm "$file"
        echo "Deleted backup: $file"
    done
fi

echo "Backup and cleanup completed."
