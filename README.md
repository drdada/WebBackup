# WebBackup
Yet another web backup. SQL and FTP backup (with mysqldump and wget)

## Features
- Backup your files via FTP
- Backup your database via Mysqldump
- Rotate backups (in days)
- Compression

## Requirement
- Mysqldump (mysql-client)
- Wget
- GZip
- Bash

## Install
### Install the requirement
`apt-get install wget gzip mysql-client`

### Download the script
`wget https://raw.githubusercontent.com/drdada/WebBackup/master/backup.sh`
### Edit it to change your creds.
`nano backup.sh`
### Make it runnable
`chmod +x backup.sh`
### Run it !
`./backup.sh`
Now you can configure cron etc...


## TODO
Tell me ?
