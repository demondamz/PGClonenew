#!/bin/bash
function sudocheck () {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    exit 0
  else
    mntcheck
  fi
}

function mntcheck() {
mnt=$(cat /var/plexguide/server.hd.path)
if [[ "$mnt" != "/mnt" ]];then 
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  SORRY !!! MOUNT DOCKER and UPLOAD DOCKER DONT WORKS WITH PROCESSING DISCS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 30
  doneokay
else
  updatesystem
fi
}
function doneokay() {
 echo
  read -p 'PRESS [ENTER] ' typed </dev/tty
  exit 0
}

function updatesystem() {
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  This can take a while
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2
updateall
uppercut
gcloudup
rclone
clone
}
function updateall() {
package_list="update upgrade dist-upgrade autoremove autoclean"
for i in ${package_list}; do
    sudo apt $i -yqq 1>/dev/null 2>&1
    echo "$i is running , please wait"
    sleep 1
done
}

function uppercut() {
ansiv=$(ansible --version | head -n1 | awk '{print $2}')
if [[ "$ansiv" -lt "2.10" ]]; then
   pip uninstall ansible 1>/dev/null 2>&1
   pip install ansible-base 1>/dev/null 2>&1
   pip install ansible 1>/dev/null 2>&1
   python3 -m pip install ansible 1>/dev/null 2>&1
fi
}

function gcloudup() {
gcloudversion=$(gcloud --version | head -n1 | awk '{print $4}')
if [[ "$gcloudversion" -lt "307" ]]; then
   curl https://sdk.cloud.google.com > /tmp/install.sh
   export CLOUDSDK_CORE_DISABLE_PROMPTS=1
   if [[ -d "/root/google-cloud-sdk" ]]; then
      rm -rf /root/google-cloud-sdk
   fi
   bash /tmp/install.sh --disable-prompts
   rm -f /tmp/install.sh
fi
}

function rclone() {
  curl -fsSL https://raw.githubusercontent.com/demondamz/RCupdate/master/rcupdate.sh | sudo bash
}

function clone() {
    sudo rm -rf /opt/pgclone
    curl -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh | sudo bash
    sudo docker volume create -d local-persist -o mountpoint=/mnt --name=unionfs 
    sudo git clone --quiet https://github.com/demondamz/PGClonenew.git /opt/pgclone
    rm -rf /opt/plexguide/menu/pgclone/pgclone.sh 
    mv /opt/pgclone/newpgclone.sh /opt/plexguide/menu/pgcloner/pgclone.sh
    sudo chown -cR 1000:1000 /opt/pgclone/ 1>/dev/null 2>&1
    sudo chmod -cR 755 /opt/pgclone 1>/dev/null 2>&1	
    sudo bash /opt/plexguide/menu/pgcloner/pgclone.sh
}

sudocheck

