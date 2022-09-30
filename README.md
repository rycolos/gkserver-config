# gkserver-config
...is the documentation and key config files to provision and run my home server — *gkserver*.

## Why “gkserver”?

Important stuff first… and I’m always fascinated by the naming conventions people apply to their projects, from boats, to guitars, to computer hardware, and software releases.

Fans of King of the Hill may recall GH aka “Good Hank,” Cotton HIll’s new baby, Hank’s half-brother, and Bobby’s newborn uncle.

<img src="https://preview.redd.it/ol24q6vy94d71.jpg?auto=webp&s=feab8a307dd1c6d0b9866f9cff7a696381778b80" width="400">

The first iteration of this server, KeplerNAS, was named after my wonderful-but-unruly cat, Kepler. I like my cat more than my home server, but sometimes he’s bad and gkserver is always good. And gkserver is certainly better than its ancestor, KeplerNAS.

## Why am I doing this?

I built the original KeplerNas for file storage because I couldn’t justify Apple’s exorbitant storage costs and my Macbook’s drive was quickly filling up. I used a Pi4 and an 8TB external drive. Hanging an external HDD off a Pi case (over USB 3.0) speeds was getting old, so I rebuilt it with better hardware in 2021. I started to run additional services, mostly containerized with [Docker](https://www.docker.com), and quickly began to outgrow the OS drive where I was storing my Docker data. Which brings us to now. 

I needed to upgrade to a 1TB OS drive (and something a bit more robust than a WD Blue). I also wanted to migrate from Linux Mint to Ubuntu Server. I originally thought it’d be nice to have a GUI option, but I haven’t used it in months in favor of SSH and tmux, so why waste the resources? 

I was dreading starting from scratch, even with most services running in Docker. Coincidentally, I had been doing some reading about IaC tools like [Ansible](https://www.ansible.com) and [Terraform](https://www.terraform.io) and thought provisioning v2 of my server would be a good project to learn more. 

After more reading, Terraform started to feel like overkill for a single on-prem sever but Ansible felt like a great fit, especially combined with Docker, to spin it up quickly and in a repeatable way. 

Like any good automation project, I certainly spent more time automating the solution than just running through my old Apple Notes checklists, but I learned a lot and can be a little less afraid of borking my system drive and starting fresh if need be. Cue xkcd:

![](https://imgs.xkcd.com/comics/automation.png)

Everything here is a work in progress, so expect frequent commits!

## System Specs

Nothing fancy here, but even these specs are far overkill for my current use case. 

- AMD Athlon 3000G APU
- Noctua NH-L9a cooler
- Gigabyte B450M motherboard
- Corsair Vengeance DDR4-3200 2x8GB ram
- SAMA IM01 MicroATX case
- EVGA SuperNova 550 PSU (way overkill, but I wanted something reliable and energy efficient)
- Storage
    - 1TB SK Gold NVME (OS and Docker data)
    - 4TB WD Blue - Primary backup drive (Syncthing from other computers, Docker data, Plex library, CCTV footage, Creative work)
    - 4TB WD Blue - Plex Library

## Provisioning with Ansible

I’m using `ansible-pull` from the local machine to run the playbook stored on this repo. I’m running everything in a single playbook for now to keep things simple, but may evolve this as I get deeper into learning Ansible. Ansible is being used to handle a handful of tasks:

- Run initial apt update and upgrade
- Install core utilities
- Install Docker and Docker Compose
- Clone this repo to get my docker-compose file and scripts related to backup, monitoring, and data retention
- Install cronjobs related to the above scripts
- Miscellaneous config tasks like create directories, set my timezone, configure git, and configure nano/vim.

## Manual tasks

Not everything is being automated, for a variety of reasons.

### Initializing

- Install [Ubuntu Server 22.04 LTS](https://ubuntu.com/download/server) locally on the machine.
- Update repos and install Ansible and Git
    - `sudo apt update && sudo apt install ansible git`
- Use `ansible-pull` to run the playbook in this repo, providing the system user (created during OS installation) as a parameter
    - `sudo ansible-pull -e "user=USER" -U https://github.com/rycolos/gkserver-config ansible/local.yml`

### Post Provisioning

- I’ll need to do a one-time transfer of my Docker data folders and secrets files for Docker and some of my scripts.
- SSH config and other hardening - I’m wary of relying on regex in Ansible for something as important as hardening my system. Given that I’d be verifying these configs manually anyhow, it didn’t seem worth giving Ansible the job.
- Internal HDD mounting and fstab edits - Similar to network tasks, I know Ansible *can* handle this, but it’s so important that I’d be verifying manually anyways so I’d rather own for now.
- rclone install and setup - I have seen reports of successful rclone configs either as a Docker container or bare metal with Ansible, but both options seem fraught with issues and setup pains. It’s a quick setup so I’ll keep it manual for now.

### Recurring

- System and Docker container updates - I prefer to vet and monitor my updates, so I do this weekly
- Backup to cold storage - I do a manual weekly clone of my backup drive to an offline drive that I keep disconnected from power when not in use

## Docker services

### Media

I use [Plex](https://hub.docker.com/r/linuxserver/plex) for on-site music streaming, and not for video.

### Backup/Sync

I use [Syncthing](https://hub.docker.com/r/linuxserver/syncthing) to backup (one-way) key folders from my Macbook in real time. I use [Pure-FTPd](https://hub.docker.com/r/stilliard/pure-ftpd/) to run an FTP server for for my Reolink CCTV cameras.

### Networking

I run [Wireguard](https://hub.docker.com/r/linuxserver/wireguard) as a VPN, primarily so I can access my security cameras away from the house. Otherwise, all of my services all locked down for local access only.

### Web

I run a [nginx](https://hub.docker.com/_/nginx) web server to host a simple admin dashboard for gkserver.  

### Monitoring/Alerting

I run of a joint stack of [Grafana](https://hub.docker.com/r/grafana/grafana/), [Prometheus](https://hub.docker.com/r/prom/prometheus), [Node Exporter](https://github.com/prometheus/node_exporter), and [cAdvisor](https://github.com/google/cadvisor) to monitor system and container metrics, as well as trigger alerts (to a Discord webhook) for cpu, memory, and temperature. This is no doubt overkill, but it was fun and educational to set up.

### Smart Home

I used to use [Home Assistant](https://hub.docker.com/_/nginx) for everything but now I’m just using it to pull in data from select IoT devices which I’ll eventually store in a db to explore in Grafana. Otherwise, I’m mostly devoted to Apple Home and use [Homebridge](https://github.com/oznu/docker-homebridge) to bring in unsupported devices in my Home. I may eventually move back to Home Assistant, but Apple Home is a little more user friendly for family.

## Other core services and utilities

- [rclone](https://rclone.org) - I backup my core backup drive to Google Drive on schedule with a cronjob. I may eventually move from GDrive to Backblaze, S3, or another option, but GDrive is working for now.
- SFTP/SCP - Call me old fashioned, but I prefer to use SCP or SFTP for any ad-hoc file transfers.
- [smartctl](https://www.smartmontools.org) for HDD monitoring - I run monthly SMART checks of my internal HDDs, scheduled with cron. I should probably start using smartd…

## Scripts

Nothing too special here — mostly some simple bash rsync scripts, a script to nuke logs and rsync versioning directories, and `discord-pipe.py`  which is used to report my completed cronjobs to a Discord server via webhook. These could be improved and made more modular, and will be in time, but they’re functional.

## What’s next?

- Start using [Portainer](https://www.portainer.io) for web admin of Docker and start using stacks rather than a single docker-compose.yml for all services
- Stream data from Home Assistant into Grafana, probably via a containerized [InfluxDB](https://www.google.com/search?client=safari&rls=en&q=influxdb&ie=UTF-8&oe=UTF-8)
- Grow it into a “homelab-lite” for my continued education — [Proxmox](https://www.proxmox.com/en/) and Terraform are on deck. I think I’ll be needing more storage…
