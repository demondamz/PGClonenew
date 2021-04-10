#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
transportselect() {
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Set Clone Method 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ 1 ] Unencrypt: Data > TDrive | Complex | Exceed 750GB Transport Cap
[ 2 ] Encrypted: Data > TDrive | Complex | Exceed 750GB Transport Cap

[Z] EXIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -rp '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty

    case $typed in
    1) echo "bu" >/var/plexguide/pgclone.transport && echo "Blitz" >/var/plexguide/pg.transport ;;
    2) echo "be" >/var/plexguide/pgclone.transport && echo "Blitz Encrypted" >/var/plexguide/pg.transport ;;
    z) exit ;;
    Z) exit ;;
    *) transportselect ;;
    esac
}
