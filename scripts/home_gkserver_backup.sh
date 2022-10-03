#!/bin/bash

logdest="/home/kepler/logs/home_gkserver_backup.log"
src1="/home/kepler"
dest1="/media/backup_main/gkserver_home"
exclude1="/home/kepler/gkserver"
trashdir="/media/backup_main/gkserver_home/gkserver_home_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

rsync -avhi --delete --exclude 'gkserver' --backup-dir=$trashdir $src1 $dest1 2>&1 | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
