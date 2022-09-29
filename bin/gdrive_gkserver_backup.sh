#!/bin/bash

logdest="/home/kepler/logs/gdrive_gkserver_backup.log"
config="/home/kepler/.config/rclone/rclone.conf"
src1="/media/kepler/backup/documents/"
dest1="gdrive:backup_gknas/documents/"
src2="/media/kepler/backup/gknas_home/"
dest2="gdrive:backup_gknas/home/"
src3="/media/kepler/plex_library/music/"
dest3="gdrive:backup_gknas/plex_library/"
trashdir="gdrive:/rclone_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

#backup docs
rclone sync $src1 $dest1 \
--config=$config \
--progress --delete-excluded --backup-dir $trashdir | tee -a $logdest

#home dir
rclone sync $src2 $dest2 \
--config=$config \
--progress --delete-excluded --backup-dir $trashdir | tee -a $logdest

#plex library
rclone sync $src3 $dest3 \
--config=$config \
--progress --backup-dir $trashdir | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
