#!/bin/bash
#
# Title:      basic parts 
# Author:     MrDoob
# GNU:        General Public License v3.0
################################################################################
deploypgblitz() {
  deployblitzstartcheck 
  # At Bottom - Ensure Keys Are Made
  # RCLONE BUILD
  echo "#------------------------------------------" >/opt/appdata/plexguide/rclone.conf
  echo "# rClone.config created over rclone " >>/opt/appdata/plexguide/rclone.conf
  echo "#------------------------------------------" >>/opt/appdata/plexguide/rclone.conf
  cat /opt/appdata/plexguide/.gdrive >>/opt/appdata/plexguide/rclone.conf
  if [[ $(cat "/opt/appdata/plexguide/.gcrypt") != "NOT-SET" ]]; then
    echo ""
    cat /opt/appdata/plexguide/.gcrypt >>/opt/appdata/plexguide/rclone.conf
  fi
  cat /opt/appdata/plexguide/.tdrive >>/opt/appdata/plexguide/rclone.conf
  if [[ $(cat "/opt/appdata/plexguide/.tcrypt") != "NOT-SET" ]]; then
    echo ""
    cat /opt/appdata/plexguide/.tcrypt >>/opt/appdata/plexguide/rclone.conf
  fi
  cat /opt/appdata/plexguide/.keys >>/opt/appdata/plexguide/rclone.conf
  deploydrives
}
deploypgmove() {
  # RCLONE BUILD
  echo "#------------------------------------------" >/opt/appdata/plexguide/rclone.conf
  echo "# rClone.config created over rclone " >>/opt/appdata/plexguide/rclone.conf
  echo "#------------------------------------------" >>/opt/appdata/plexguide/rclone.conf

  cat /opt/appdata/plexguide/.gdrive >/opt/appdata/plexguide/rclone.conf

  if [[ $(cat "/opt/appdata/plexguide/.gcrypt") != "NOT-SET" ]]; then
    echo ""
    cat /opt/appdata/plexguide/.gcrypt >>/opt/appdata/plexguide/rclone.conf
  fi
  deploydrives
}

dockervolumen() {
dovolcheck=$(docker volume ls | grep unionfs)
if [[ "$dovolcheck" == "unionfs" ]]; then
tee <<-EOF
     🚀      Docker Volume exist | skipping
EOF
else
tee <<-EOF
     🚀      Creating Docker Volume starting
     🚀      this can take a long time  
EOF
curl -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh | sudo bash
docker volume create -d local-persist -o mountpoint=/mnt --name=unionfs 1>/dev/null 2>&1
tee <<-EOF
     🚀      Creating Docker Volume created
EOF
fi
}
updatesystem() {
tee <<-EOF
     🚀      System will be updated now 
	     this can take a long time  
EOF
  # update system to new packages
   ansible-playbook /opt/pgclone/ymls/update.yml 1>/dev/null 2>&1
tee <<-EOF
     🚀      System is up2date now
EOF
}
stopmunts() {
mount=$(docker ps --format '{{.Names}}' | grep "mount")
if [[ "$mount" == "mount" ]]; then 
   docker stop mount 1>/dev/null 2>&1
   fusermount -uzq /mnt/unionfs 1>/dev/null 2>&1
else
   service stop pgunion >/dev/null 2>&1
   fusermount -uzq /mnt/unionfs 1>/dev/null 2>&1
   rm -f /etc/systemd/system/pgunion.service 1>/dev/null 2>&1
fi
}
removeoldui() {
UI=$(docker ps --format '{{.Names}}' | grep "pgui")
if [[ "$UI" == "pgui" ]]; then 
   docker stop pgui 1>/dev/null 2>&1
   docker rm pgui 1>/dev/null 2>&1
   rm -rf /opt/appdata/pgui/ 1>/dev/null 2>&1
fi
}
update_pip() {
pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 1>/dev/null 2>&1
}
stopdocker() {
  container=$(docker ps -aq --format '{{.Names}}' | sed '/^$/d' | grep -E 'ple|arr|emby|jelly')
  docker stop $container 1>/dev/null 2>&1
}
vnstat() {
  apt-get install ethtool vnstat vnstati -yqq 2>&1 >>/dev/null
     export DEBIAN_FRONTEND=noninteractive
     network=$(ifconfig | grep -E 'eno1|enp|ens5' | awk '{print $1}' | sed -e 's/://g')
     sed -i 's/eth0/'$network'/g' /etc/vnstat.conf
     sed -i '/UseLogging/s/2/0/' /etc/vnstat.conf
     sed -i '/RateUnit/s/1/0/' /etc/vnstat.conf
     sed -i '/UnitMode/s/0/1/' /etc/vnstat.conf
     sed -i 's/Locale "-"/Locale "LC_ALL=en_US.UTF-8"/g' /etc/vnstat.conf
     /etc/init.d/vnstat restart 1>/dev/null 2>&1
}
mover() {
hdpath="$(cat /var/plexguide/server.hd.path)"
if [[ -d "$hdpath/move" ]]; then
   if [[ ! -x "$(command -v rsync)" ]]; then
      apt-get install rsync -yqq
   fi
   if [[ $(find "$hdpath/move" -type f | wc -l) -gt 0 ]]; then
      rsync "$hdpath/move/" "$hdpath/downloads/" -a --info=progress2 -hv --remove-source-files
      chown -R 1000:1000 "$hdpath/downloads"
   fi
   if [[ -x "$(command -v rsync)" ]]; then
      apt-get --purge remove rsync -yqq
   fi
fi
}
vault() {
  rm -rf /opt/pgvault
  git clone --quiet https://github.com/mrfret/PTS-Vault.git /opt/pgvault
  rm -rf /opt/plexguide/menu/pgvault/pgvault.sh
  mv /opt/pgvault/newpgvault.sh /opt/plexguide/menu/pgcloner/pgvault.sh
  chown -cR 1000:1000 /opt/pgvault/ 1>/dev/null 2>&1
  chmod -cR 755 /opt/pgvault 1>/dev/null 2>&1
}
deploydockermount() {
tee <<-EOF
     🚀      Deploy of Docker Mounts started
EOF
   ansible-playbook /opt/pgclone/ymls/remove-2.yml 1>/dev/null 2>&1
   ansible-playbook /opt/pgclone/ymls/mounts.yml 1>/dev/null 2>&1
tee <<-EOF
     🚀      Deploy of Docker Mounts done
EOF
}
norcloneconf() {
rcc=/opt/appdata/plexguide/rclone.conf
if [[ ! -f "$rcc" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ⛔ Fail Notice for deploy of Docker 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     Sorry we cant Deploy the Docker.
     We cant find any rclone.conf file 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ⛔ Fail Notice for deploy of Docker
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed </dev/tty
clonestart
else
  echo ""
fi
}
deploydockeruploader() {
ansible-playbook /opt/pgclone/ymls/uploader.yml 1>/dev/null 2>&1
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     💪     DEPLOYED sucessfully !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}
### Docker Uploader Deploy end ##
deploydrives() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      🚀 Conducting RClone Mount Checks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    stopdocker
    vnstat
    norcloneconf
    removeoldui
    vault
    cleanlogs
    stopmunts
    mover
    testdrive
    updatesystem
    update_pip
    stopmunts
    unmountdrive
    dockervolumen
    deploydockeruploader	
    deploydockermount
    doneokay
    clonestart
}

########################################################################################
doneokay() {
 echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
}
testdrive() {
IFS=$'\n'
filter="$1"
config=/opt/appdata/plexguide/rclone.conf
mapfile -t mounttest < <(eval rclone listremotes --config=${config} | grep "$filter" | sed '/pgunion/d')
for i in ${mounttest[@]}; do
    rclone lsd --config=${config} $i | head -n1
    echo "$i = Passed"
done
}
unmountdrive() {
IFS=$'\n'
filter="$1"
config=/opt/appdata/plexguide/rclone.conf
mapfile -t mounttest < <(eval rclone listremotes --config=${config} | grep "$filter" | sed '/GDSA/d' | sed '/pgunion/d')
for i in ${mounttest[@]}; do
    service stop $i 1>/dev/null 2>&1
    fusermount -uzq /mnt/$i 1>/dev/null 2>&1
    echo "unmount of $i = Passed"
    rm -f /etc/systemd/system/$i.service 1>/dev/null 2>&1
done
}

################################################################################
deployblitzstartcheck() {
  pgclonevars
  if [[ "$displaykey" == "0" ]]; then
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ⛔ Fail Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  💬  There are [0] keys generated for Blitz! Create those first!
  NOTE: 

  Without any keys, Blitz cannot upload any data without the use
  of service accounts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed </dev/tty
    clonestart
  fi
}
################################################################################
cleanlogs() {
  echo "Prune service logs..."
  journalctl --flush 1>/dev/null 2>&1
  journalctl --rotate 1>/dev/null 2>&1
  journalctl --vacuum-time=1s 1>/dev/null 2>&1
  truncate -s 0 /var/plexguide/logs/*.log 1>/dev/null 2>&1
  rm -rf /var/plexguide/logs/ 1>/dev/null 2>&1
  find /var/logs -name "*.gz" -delete 1>/dev/null 2>&1
}
prunedocker() {
  echo "Prune docker images and volumes..."
  docker system prune -af 1>/dev/null 2>&1
}
