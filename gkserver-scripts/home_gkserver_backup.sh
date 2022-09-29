#!/bin/bash

logdest="/home/kepler/logs/home_gkserver_backup.log"
src1="/home/kepler"
dest1="/media/kepler/backup/gknas_home"
trashdir="/media/kepler/backup/gknas_home/gknas_home_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

rsync -avhi --delete --exclude 'docker' --backup-dir=$trashdir $src1 $dest1 | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
