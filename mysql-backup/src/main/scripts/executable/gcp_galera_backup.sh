#!/bin/sh
echo "Starting db backup at $(date)"
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
REGION=$(mysql --user="$1" --password="$2" -e "show global status like '%wsrep_incoming_addresses%'" | grep wsrep | awk '{print $2}' | grep 172 | wc -l)
cd /product/galera-backup
if [ $REGION -eq 1 ] ;
then 
	echo "Taking MySQL backup"
	mysqldump --all-databases --single-transaction --quick --lock-tables=false --user="$1" --password="$2" | gzip -cf > telus-galera-full-backup-$DATE_WITH_TIME.sql.gz
	echo "Backup Completed"
	sleep 3
	echo "Encrypting the Backup file"
	openssl enc -aes-256-cbc -in telus-galera-full-backup-$DATE_WITH_TIME.sql.gz -out telus-galera-full-backup-$DATE_WITH_TIME.file -pass pass:Sql123
	echo "Encryption completed"
	echo "Uploading to GCS bucket $3"
	gsutil -m cp telus-galera-full-backup-$DATE_WITH_TIME.file gs://$3/galera/
	echo "File uploaded to GCS Bucket gs://$3/galera/"
	echo "Removing SQL file"
	rm -rf *.sql
	echo "Removing Encrypted SQL file"
	rm -rf *.file
	echo "Removing sql.gz file"
	rm -rf *.sql.gz
    echo "Removing old log files from /product/galera-backup folder"
	find /product/galera-backup -name "*.log" -type f -mtime +14 -delete
else 
	echo "Job running on active region, skipping dumb"
fi
echo "Fininshed db backup at $(date)"