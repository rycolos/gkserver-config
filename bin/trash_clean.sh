#!/bin/bash

days=30
days2=60

logdest="/home/kepler/logs/retention.log"
logsrc="/home/kepler/logs"
trashsource1="/media/kepler/backup/plex_library/plex_library_trash"
trashsource2="/media/kepler/backup/gknas_home/gknas_home_trash"
trashsource3="/media/kepler/backup/docker-data/docker-data_trash/$(date +%m-%d-%Y)"
trashsource4="/media/kepler/backup/cctv/"

echo $(date) >> $logdest
echo "" >> $logdest

#prune logs after 30d
find $logsrc -mtime +$days -delete -print | tee -a $logdest

#prune backup_trash folders after 30d
find $trashsource1 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print | tee -a $logdest
find $trashsource2 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print | tee -a $logdest
find $trashsource3 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print | tee -a $logdest

#prune cctv trash after 60d
find $trashsource4 -mindepth 1 -mtime +$days2 -exec rm -rv {} + -print | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
