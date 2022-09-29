#!/bin/bash

logdest="/home/kepler/logs/docker_gkserver_backup.log"
src1="/home/kepler/docker/docker-data"
dest1="/media/kepler/backup/docker-data"
trashdir="/media/kepler/backup/docker-data/docker-data_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

#stop docker
/usr/local/bin/docker-compose -f /home/kepler/docker/docker-compose.yml stop

rsync -avhi --delete --backup-dir=$trashdir $src1 $dest1 | tee -a $logdest

#start docker
/usr/local/bin/docker-compose -f /home/kepler/docker/docker-compose.yml start

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest