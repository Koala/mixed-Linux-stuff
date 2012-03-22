#!/bin/bash
#
# savedebdata-1.1.sh
#
# Written by Gerhard Brauer <gerhard.brauer@web.de> 2007
# after a discussion in debian-user-german. Thanks to all who
# gave a response/comment and to all on this mailing list who
# impart their knowledge there.
#
# Backup important files and settings from your debian system.
#
# Disclaimer: This script is NOT a replacement for a real backup
#             of your system! See it as a reserve magazine when
#             you draw in the battle of restoring.
#
# Hint: If you do a really backup of your system you don't need this!
# Hint: Install debconf-utils for full use.
#
# You:  Edit SYD_Dir, SYD_TGZ and hd_with_mbr to your local conditions.
# You:  you must be root to have access to all needed data.
#
# [Koala] - V 1.1 - 03.01.2009
# - Trennung von Archivverzeichnis und Archivname in jeweilige Variable
# - remove old content from Directory for saving data before use
##
###

DATE=`date +%y%m%d`
# Directory for saving data
SYD_DIR="/var/local/saveyourdeb"
# Location of tar archive from above directory
SYD_TGZ="/var/local"
# Archiv name
ARC_NAME="saveyourdeb-$(hostname)_$DATE.tar.gz"
# entgueltiges Backupdir
BAK_DIR="/adaten/Backup/debian/saveyourdeb"
###
# Device where your master boot record is located
hd_with_mbr=/dev/hda
##
###
###
###
# With Parameter -q we will be quiet (for cron etc)
if [ ${1:-""} = "-q" ]; then
  NOQUIET=false
else
  NOQUIET=true
fi
##
###
$NOQUIET && echo "SaveYourDeb directory is" "$SYD_DIR""... "
if [ ! -d $SYD_DIR ]; then
  mkdir $SYD_DIR 2>/dev/null
  $NOQUIET && echo " -> Creating $SYD_DIR..."
else
  # the directory exist, remove the content ...
  $NOQUIET && echo " -> Remove content from $SYD_DIR..."
  rm --preserve-root $SYD_DIR/* 2>/dev/null
fi
##
###
# Save partition table
$NOQUIET && echo " -> Saving partition table..."
fdisk -l > $SYD_DIR/fdisk.table
##
###
# Save the master boot record
$NOQUIET && echo " -> Saving MBR from $hd_with_mbr..."
dd if=$hd_with_mbr of=$SYD_DIR/mbr.img bs=512 count=1 2>/dev/null
##
###
# Save /etc as tar.gz
$NOQUIET && echo " -> Saving /etc as tar.gz archive..."
tar czf $SYD_DIR/etc.tar.gz /etc 2>/dev/null
##
###
# Save list of loaded modules
$NOQUIET && echo " -> Saving list of loaded modules..."
lsmod > $SYD_DIR/lsmod-$(uname -r).list
##
###
# Save list of installed, deleted or purged packages
# This could be reread by dpkg --set-selections
$NOQUIET && echo " -> Saving dpkg selections..."
dpkg --get-selections "*" > $SYD_DIR/dpkg-selections.list
##
###
# Save dpkg and aptitude status files
$NOQUIET && echo " -> Saving dpkg and aptitude status files..."
cp /var/lib/aptitude/pkgstates $SYD_DIR/aptitude.pkgstates
cp /var/lib/dpkg/status $SYD_DIR/dpkg.status
##
###
# Save debconf database for reread by debconf-set-selections
# Note: package debconf-utils must be installed!
if [ -x /usr/bin/debconf-get-selections ]; then
  $NOQUIET && echo " -> Saving debconf selections..."
  debconf-get-selections > $SYD_DIR/debconf.selections
else
  $NOQUIET && echo " -> NOT saving debconf selections. Install debconf-utils"
fi
##
###
# Save some maybe usefull infos from /proc
$NOQUIET && echo " -> Saving some informations from /proc..."
cat /proc/cpuinfo    > $SYD_DIR/proc-cpuinfo
cat /proc/interrupts > $SYD_DIR/proc-interrupts
cat /proc/ioports    > $SYD_DIR/proc-ioports
cat /proc/meminfo    > $SYD_DIR/proc-meminfo
cat /proc/modules    > $SYD_DIR/proc-modules
cat /proc/mounts     > $SYD_DIR/proc-mounts
cat /proc/partitions > $SYD_DIR/proc-partitions
cat /proc/swaps      > $SYD_DIR/proc-swaps
##
###
$NOQUIET && echo "Finished."
# Make a tar.gz from $SYD_DIR
$NOQUIET && echo "Creating tar archive $SYD_TGZ/$ARC_NAME"
$NOQUIET && echo "from $SYD_DIR..."
tar czf $SYD_TGZ/$ARC_NAME $SYD_DIR 2>/dev/null

# [Koala] Rechteanpassung - only root access
chmod 0600 $SYD_TGZ/$ARC_NAME
chmod 0700 $SYD_DIR
# [Koala] in entgueltiges Backuparchiv kopieren
$NOQUIET && echo
$NOQUIET && echo "Copy archive to: $BAK_DIR/$ARC_NAME"
cp $SYD_TGZ/$ARC_NAME $BAK_DIR/$ARC_NAME
$NOQUIET && echo


##
###
#$NOQUIET && echo
#$NOQUIET && echo "With parameter -q you could make this"
#$NOQUIET && echo "script quiet for ex. cron"
#
