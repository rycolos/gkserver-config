#!/bin/bash

logdest="/home/kepler/logs/docker_gkserver_backup.log"
src1="/home/kepler/gkserver/docker-data"
dest1="/media/backup_main/docker-data"
trashdir="/media/backup_main/docker-data/docker-data_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

#stop docker
/usr/bin/docker compose -f /home/kepler/gkserver/docker-compose/docker-compose.yml stop

rsync -avhi --delete --backup-dir=$trashdir $src1 $dest1 2>&1| tee -a $logdest

#start docker
/usr/bin/docker compose -f /home/kepler/gkserver/docker-compose/docker-compose.yml start

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest