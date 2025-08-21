# Upload Files to Google Drive from Ubuntu Server Using `gdrive`

This guide demonstrates how to upload files to Google Drive from an Ubuntu server using the `gdrive` command-line tool.

## Prerequisites

- An Ubuntu server (18.04 or newer)
- A Google account
- Internet access
- A Google Cloud project with Drive API enabled

## Step 1: Install `gdrive`

1. **Download the latest release**:

   ```bash
   wget https://github.com/prasmussen/gdrive/releases/download/2.1.1/gdrive-linux-x64
   ```

2. **Rename the downloaded file**:

   ```bash
   mv gdrive-linux-x64 gdrive
   ```

3. **Make it executable**:

   ```bash
   chmod +x gdrive
   ```

4. **Move it to a directory in your PATH**:

   ```bash
   sudo mv gdrive /usr/local/bin/
   ```

## Step 2: Set up Google API Authentication

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project or select an existing one.
3. Navigate to **APIs & Services > Library** and enable the **Google Drive API**.
4. Go to **APIs & Services > Credentials** and create an **OAuth 2.0 Client ID**:
   - Choose **Desktop app** as the application type.
   - Download the JSON credentials file.
5. Save the credentials JSON file to your server, e.g., `/home/user/gdrive_credentials.json`.

## Step 3: Authenticate `gdrive`

1. Run `gdrive` with the credentials file:

   ```bash
   gdrive about --service-account /home/user/gdrive_credentials.json
   ```

2. Follow the on-screen instructions to authenticate:
   - It will open a browser link.
   - Allow access to your Google account.
   - Copy the provided authorization code.
   - Paste it back into the terminal.

## Step 4: Upload Files

- **Upload a single file**:

  ```bash
  gdrive upload /path/to/your/file
  ```

- **Upload a folder**:

  ```bash
  gdrive upload -r /path/to/your/folder
  ```

- **Upload to a specific folder on Google Drive**:

  First, get the folder ID:

  ```bash
  gdrive list
  ```

  Then, upload the file:

  ```bash
  gdrive upload --parent <folder_id> /path/to/your/file
  ```

## Step 5: Automate Uploads with Cron

To automate uploads, you can create a cron job:

1. **Edit the crontab**:

   ```bash
   crontab -e
   ```

2. **Add a line to upload a file every day at 3:30 AM**:

   ```bash
   30 3 * * * /usr/local/bin/backup_upload.sh >> /var/log/backup_upload.log 2>&1
   ```

   Replace `/usr/local/bin/backup_upload.sh` with the path to your script.

## Notes

- Ensure that the `gdrive` binary is executable and located in a directory included in your system's PATH.
- The first time you run `gdrive`, it will prompt you to authenticate. Follow the on-screen instructions to complete the authentication process.
- For more advanced usage and options, refer to the official [gdrive GitHub repository](https://github.com/prasmussen/gdrive).
