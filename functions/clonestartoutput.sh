#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
sudocheck() {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
 sleep 30 && exit 0
fi
mntcheck
}
mntcheck() {
mnt=$(cat /var/plexguide/server.hd.path)
if [[ "$mnt" != "/mnt" ]];then 
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  SORRY !!! MOUNT DOCKER and UPLOAD DOCKER DONT WORKS WITH PROCESSING DISCS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
sleep 30 && exit 0
fi
}

clonestartoutput() {
    pgclonevars
echo "ACTIVELY DEPLOYED: 	  $dversionoutput "
echo ""
    if [[ "$demo" == "ON " ]]; then mainid="********"; else mainid="$pgcloneemail"; fi
    if [[ "$transport" == "bu" ]]; then
        tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Google Account Login     [ $mainid ]
[2] Project Name             [ $pgcloneproject ]
[3] Client ID & Secret       [ ${pgcloneid} ]
[4] TDrive Label             [ $tdname ]
[5] TDrive OAuth             [ $tstatus ]
[6] GDrive OAuth             [ $gstatus ] 
[7] Key Management           [ $displaykey ] Built
[8] TDrive	             ( E-Mail Share Generator )
EOF
    elif [[ "$transport" == "be" ]]; then
        tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Google Account Login     [ $mainid ]
[2] Project Name             [ $pgcloneproject ]
[3] Client ID & Secret       [ ${pgcloneid} ]
[4] Passwords                [ $pstatus ]
[5] TDrive Label             [ $tdname ]
[6] TDrive | TCrypt          [ $tstatus ] - [ $tcstatus ]
[7] GDrive | GCrypt          [ $gstatus ] - [ $gcstatus ]
[8] Key Management           [ $displaykey ] Built
[9] TDrive	             ( E-Mail Share Generator )

EOF
    fi
}
errorteamdrive() {
    if [[ "$tdname" == "NOT-SET" ]]; then
        tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Setup the TDrive Label First!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Set up your TDrive Label prior to executing the TDrive OAuth.
Basically, we cannot authorize a TeamDrive without knowing which
TeamDrive is being utilized first!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed </dev/tty
        clonestart
    fi
}
clonestart() {
    pgclonevars
    if [[ "$transport" != "bu" && "$transport" != "be" ]]; then
        rm -rf /var/plexguide/pgclone.transport 1>/dev/null 2>&1
        mustset
    fi
    if [[ "$transport" == "bu" ]]; then
        outputversion="Unencrypted Mounts"
        output="TDrive"
    elif [[ "$transport" == "be" ]]; then
        outputversion="Encrypted Mounts"
        output="TCrypt"
    fi
        tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Welcome to rClone
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        clonestartoutput
        dockerstatusuploader
        dockerstatusmount
        tee <<-EOF
____________________________________________________
Docker Status :
Uploader               [ $dstatus ] - [ $output ]
Mount                  [ $mstatus ] - [ $output ]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] Deploy Mounts and Uploader    [ $outputversion ]

[O] Options

[B] Backup Rclone Settings
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Z] Exit

EOF
        read -rp '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty
        clonestartactions
}
dockerstatusuploader() {
upper=$(docker ps --format '{{.Names}}' | grep "uploader")
if [[ "$upper" == "uploader" ]]; then
 dstatus="✅ DEPLOYED"
  else dstatus="⚠️ NOT DEPLOYED"; fi
}
dockerstatusmount() {
mount=$(docker ps --format '{{.Names}}' | grep "mount")
if [[ "$mount" == "mount" ]]; then
 mstatus="✅ DEPLOYED"
  else mstatus="⚠️ NOT DEPLOYED"; fi
}
clonestartactions() {
    if [[ "$transport" == "bu" ]]; then
        case $typed in
        1) glogin ;;
        2) exisitingproject ;;
        3) keyinputpublic ;;
        4) publicsecretchecker && tlabeloauth ;;
        5) publicsecretchecker && tlabelchecker && echo "tdrive" >/var/plexguide/rclone/deploy.version && oauth ;;
        6) publicsecretchecker && echo "gdrive" >/var/plexguide/rclone/deploy.version && oauth ;;
        7) publicsecretchecker && tlabelchecker &&  projectnamecheck && keystart && gdsaemail ;;
        8) publicsecretchecker && tlabelchecker &&  projectnamecheck && deployblitzstartcheck && emailgen ;;
        z) exit ;;
        Z) exit ;;
        a) publicsecretchecker && tlabelchecker && deploypgblitz ;;
        A) publicsecretchecker && tlabelchecker && deploypgblitz ;;
        b) publicsecretchecker &&  keybackup ;;
        B) publicsecretchecker &&  keybackup ;;
        o) optionsmenu ;;
        O) optionsmenu ;;
        *) clonestart ;;
        esac

    elif [[ "$transport" == "be" ]]; then
        case $typed in
        1) glogin ;;
        2) exisitingproject ;;
        3) keyinputpublic ;;
        4) publicsecretchecker && blitzpasswordmain ;;
        5) publicsecretchecker && tlabeloauth ;;
        6) publicsecretchecker && passwordcheck && tlabelchecker && echo "tdrive" >/var/plexguide/rclone/deploy.version && oauth ;;
        7) publicsecretchecker && passwordcheck && echo "gdrive" >/var/plexguide/rclone/deploy.version && oauth ;;
        8) publicsecretchecker && passwordcheck && tlabelchecker &&  projectnamecheck && keystart && gdsaemail ;;
        9) publicsecretchecker && passwordcheck && tlabelchecker &&  projectnamecheck && deployblitzstartcheck && emailgen ;;
        z) exit ;;
        Z) exit ;;
        a) publicsecretchecker && passwordcheck && tlabelchecker && deploypgblitz ;;
        A) publicsecretchecker && passwordcheck && tlabelchecker && deploypgblitz ;;
        b) publicsecretchecker && passwordcheck &&  keybackup ;;
        B) publicsecretchecker && passwordcheck &&  keybackup ;;
        o) optionsmenu ;;
        O) optionsmenu ;;
        *) clonestart ;;
        esac
    fi
    clonestart
}
# For Blitz
optionsmenu() {
    pgclonevars
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Options Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Transport Select             | INFO: Change Transport Type
[2] Destroy All Service Keys     | WARN: Wipes All Keys for the Project
[3] Create New Project           | WARN: Resets Everything
[4] Demo Mode                    | Hide the E-Mail Address on the Front

[5] Create a TeamDrive

NOTE: When creating a NEW PROJECT, the USER must create the
CLIENT ID and SECRET for that project! We will assist in creating the
project and enabling the API! Everything resets when complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -rp '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty

    case $typed in
    1)  transportselect && clonestart ;;
    2)  deletekeys ;;
    3)  projectnameset ;;
    4)  demomode ;;
    5)  ctdrive ;;
    Z)  clonestart ;;
    z)  clonestart ;;
    *)  optionsmenu ;;
    esac
    optionsmenu
}
# For Move
optionsmenumove() {
    pgclonevars
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Options Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Transport Select           | INFO: Change Transport Type

NOTE: When creating a NEW PROJECT, the USER must create the
CLIENT ID and SECRET for that project! We will assist in creating the
project and enabling the API! Everything resets when complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -rp '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty

    case $typed in
    1) transportselect && clonestart ;;
    Z) clonestart ;;
    z) clonestart ;;
    *) optionsmenu ;;
    esac
    optionsmenu
}
demomode() {
    if [[ "$demo" == "OFF" ]]; then
        echo "ON " >/var/plexguide/pgclone.demo
    else echo "OFF" >/var/plexguide/pgclone.demo; fi

    pgclonevars
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 DEMO MODE IS NOW: $demo | PRESS [ENTER] to CONFIRM!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -rp '' typed </dev/tty
    optionsmenu
}
