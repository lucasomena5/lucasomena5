#!/bin/sh
echo "Starting db backup at $(date)"
DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`

/product/cassandra/bin/./cqlsh --ssl --cqlshrc=/opt/cqlshrc -e 'select keyspace_name from system_schema.keyspaces;' > /tmp/keyspace_names_$DATE_WITH_TIME.txt

if [[ $(wc -l </tmp/keyspace_names_$DATE_WITH_TIME.txt) -ge 2 ]]; then
    sed -i '1,3d' /tmp/keyspace_names_$DATE_WITH_TIME.txt
fi

if [[ $(wc -l </tmp/keyspace_names_$DATE_WITH_TIME.txt) -ge 2 ]]; then
    head -n -2 /tmp/keyspace_names_$DATE_WITH_TIME.txt > /tmp/tmp_$DATE_WITH_TIME.txt && mv /tmp/tmp_$DATE_WITH_TIME.txt /tmp/keyspace_names_$DATE_WITH_TIME.txt
fi

cd /product/cassandra-backup
mkdir -p ./backup-$DATE_WITH_TIME/schemas
mkdir -p ./backup-$DATE_WITH_TIME/snapshot

echo "keyspaces identified"
cat /tmp/keyspace_names_$DATE_WITH_TIME.txt
while read p; do
  echo "Creating backup for $p"
  /product/cassandra/bin/./cqlsh --ssl --cqlshrc=/opt/cqlshrc -e "desc keyspace $p" > /product/cassandra-backup/backup-$DATE_WITH_TIME/schemas/schema-$p-$DATE_WITH_TIME.cql 
  /product/cassandra/bin/./nodetool snapshot -t snap-$p-$DATE_WITH_TIME "$p"
  find /product/cassandra/data/data -type f -path "*snapshots/snap-$p-$DATE_WITH_TIME*" -printf %P\\0 | rsync -avP --files-from=- --from0 /product/cassandra/data/data/ /product/cassandra-backup/backup-$DATE_WITH_TIME/snapshot/
  sleep 3
done </tmp/keyspace_names_$DATE_WITH_TIME.txt

echo "Compressing the Backup file"
tar czf telus-cassandra-full-backup-$DATE_WITH_TIME.tar.gz /product/cassandra-backup/backup-$DATE_WITH_TIME/
echo "Compression completed"

echo "Encrypting the Backup file"
openssl enc -aes-256-cbc -in telus-cassandra-full-backup-$DATE_WITH_TIME.tar.gz -out telus-cassandra-full-backup-$DATE_WITH_TIME.file -pass pass:Sql123
echo "Encryption completed"

echo "Uploading to GCS bucket $1"
gsutil -m cp telus-cassandra-full-backup-$DATE_WITH_TIME.file gs://$1/cassandra/
echo "File uploaded to GCS Bucket gs://$1/cassandra/"

echo "Removing temporary backup folder"
rm -rf /product/cassandra-backup/backup-$DATE_WITH_TIME/
rm -rf /product/cassandra-backup/*.tar.gz 
rm -rf /product/cassandra-backup/*.file 

echo "Removing old log files from /product/cassandra-backup/ folder"
find /product/cassandra-backup/ -name "*.log" -type f -mtime +14 -delete

echo "Fininshed db backup at $(date)"
