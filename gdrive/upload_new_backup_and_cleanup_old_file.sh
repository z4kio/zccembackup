#!/bin/bash
# Backup compression and upload script (for Carbonio/Zextras)

# Backup directory
BACKUP_DIR="/opt/zextras/backup"

# Google Drive Parent Folder ID
PARENT_ID="YOUR_DIRECTORY_ID"

# Timestamp for archive name
DATE=$(date +%Y%m%d-%H%M%S)

# Number of recent backups to keep in Google Drive
KEEP=1

# Function to compress and upload latest backup directory
compress_and_upload() {
    prefix=$1
    latest_dir=$(ls -td ${BACKUP_DIR}/${prefix}-* 2>/dev/null | head -n 1)

    if [[ -d "$latest_dir" ]]; then
        dirname=$(basename "$latest_dir")
        archive="/tmp/${dirname}-${DATE}.tgz"

        echo "Compressing $latest_dir -> $archive"
        tar -czf "$archive" -C "$BACKUP_DIR" "$dirname"

        echo "Uploading $archive to Google Drive..."
        gdrive files upload --parent "$PARENT_ID" "$archive"

        # Remove local archive after upload
        rm -f "$archive"

        # Cleanup old files from Google Drive
        echo "Cleaning up old backups in Google Drive for prefix: $prefix"
        file_list=$(gdrive files list --query "'$PARENT_ID' in parents and name contains '$prefix'" --order-by "createdTime desc" --skip-header | awk '{print $1}')
        
        count=0
        for file_id in $file_list; do
            count=$((count+1))
            if [[ $count -gt $KEEP ]]; then
                echo "Deleting old file ID: $file_id"
                gdrive files delete "$file_id"
            fi
        done
    else
        echo "No directory found for prefix: $prefix"
    fi
}

# Process both backup types
compress_and_upload "full"
compress_and_upload "distlist"
