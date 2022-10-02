#!/bin/bash

logdest="/home/kepler/logs/external_gkserver_backup.log"
src1="/media/backup_main"
dest1="/media/backup_2T_port"
trashdir="/media/backup_2T_port/gkserver_backup_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

rsync -avhi --delete --no-perms --no-group --no-owner \
--backup-dir=$trashdir \
$src1 $dest1 2>&1 | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest