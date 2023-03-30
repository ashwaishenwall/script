#!/bin/sh
now="$(date +'%d_%m_%Y_%H_%M_%S')"
mkdir -p /data/$now
filename="db_backup_$now"
backupfolder="/data/$now"
fullpathbackupfile="$backupfolder/$filename"
fullpathbackupfile1="/data"
logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".txt
find "$backupfolderi1" -name *.zip -mtime 1 -exec rm {} \;

MYSQL_HOST="prod-read-replica-bitqik.c1g0nef0ra87.us-east-1.rds.amazonaws.com"
MYSQL_PORT="3306"
MYSQL_DATABASE="dbname"
MYSQL_USER="admin"
MYSQL_PASSWORD="TexemJRwM5RDnZfm"
NOW=`date "+%Y-%b-%d %H:%M"`
AMAZON_S3_BUCKET="s3://prod-mysql-backup/"


DBS=$(mysql -u admin -h "prod-read-replica-bitqik.c1g0nef0ra87.us-east-1.rds.amazonaws.com" -p${MYSQL_PASSWORD} -Bse 'show databases' | egrep -v '^Database$|hold$' | grep -v 'performance_schema\|information_schema')

    for db in ${DBS[@]};
do 
	dbs="${fullpathbackupfile}_$db.sql"
       echo "$db backup"	
echo "$dbs"
       mysqldump  -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} --quote-names --opt --single-transaction --quick $db > $dbs
done

zip -r /data/${filename}.zip  /data/$now
 
 rm -rf /data/$now
echo "mysqldump End at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
NOW=`date "+%Y-%b-%d %H:%M"`
aws s3 cp /data/${filename}.zip ${AMAZON_S3_BUCKET}
