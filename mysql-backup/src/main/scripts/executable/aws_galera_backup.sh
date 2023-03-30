#!/bin/sh
echo "starting db backup at $(date)"
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
export AWS_CONFIG_FILE="/home/avs-user/.aws/config"
cd /product/galera-backup
rm -rf /product/galera-backup/*.sql
rm -rf /product/galera-backup/*.file
echo "Taking MySQL backup"
mysqldump --all-databases --single-transaction --quick --lock-tables=false --user="$1" --password="$2"> telus-galera-full-backup-$DATE_WITH_TIME.sql
echo "Backup Completed"
sleep 3
echo "encrypting the Backup file"
openssl enc -aes-256-cbc -in telus-galera-full-backup-$DATE_WITH_TIME.sql -out telus-galera-full-backup-$DATE_WITH_TIME.file -pass pass:Sql123
echo "encryption completed"
ls
echo "uploading to s3"
aws s3 cp telus-galera-full-backup-$DATE_WITH_TIME.file s3://$3/ --no-progress
echo "file uploaded to s3 "
echo "Removing SQL file"
rm -rf *.sql
echo "Removing Encrypted SQL file"
rm -rf *.file
echo "fininshed db backup at $(date)"
