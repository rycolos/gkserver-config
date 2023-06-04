#!/bin/bash

logdest="/home/kepler/logs/plex_gkserver_backup.log"
src1="/media/plex_library"
dest1="/media/backup_main/plex_library"
trashdir="/media/backup_main/plex_library/plex_library_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

rsync -avhi --delete --backup-dir=$trashdir \
$src1 $dest1 2>&1 | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
