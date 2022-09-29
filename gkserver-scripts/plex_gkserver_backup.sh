#!/bin/bash

logdest="/home/kepler/logs/plex_gkserver_backup.log"
src1="/media/kepler/plex_library/music"
dest1="/media/kepler/backup/plex_library/music"
trashdir="/media/kepler/backup/plex_library/plex_library_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

rsync -avhi --delete --backup-dir=$trashdir \
$src1 $dest1 | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
