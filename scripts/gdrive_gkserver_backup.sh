#!/bin/bash

logdest="/home/kepler/logs/gdrive_gkserver_backup.log"
config="/home/kepler/.config/rclone/rclone.conf"
src1="/media/backup_main/documents/"
dest1="gdrive:backup_gkserver/documents/"
src2="/media/backup_main/gkserver_home/"
dest2="gdrive:backup_gkserver/home/"
src3="/media/plex_library/music/"
dest3="gdrive:backup_gkserver/plex_library/"
trashdir="gdrive:/rclone_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

#backup docs
rclone sync $src1 $dest1 \
--config=$config \
--progress --delete-excluded --backup-dir $trashdir 2>&1 | tee -a $logdest

#home dir
rclone sync $src2 $dest2 \
--config=$config \
--progress --delete-excluded --backup-dir $trashdir 2>&1 | tee -a $logdest

#plex library
rclone sync $src3 $dest3 \
--config=$config \
--progress --backup-dir $trashdir 2>&1 | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
