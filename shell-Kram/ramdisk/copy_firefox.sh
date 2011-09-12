#!/bin/sh
#
# Pruefe ob das Verzeichnis firefox in der Ramdisk vorhanden ist.
# Wenn nicht, dann kopiere es und starte firefox.
# Wenn doch, dann starte firefox.
#

#######################################################################
#                 Einstellungen Anfang
#######################################################################

# Pfad zur RAM-Disk
RAM_DISK="/ramdisc"

# Verzeichnis für Eclipse in der Ramdisk
SYD_DIR="${RAM_DISK}/firefox6"

# Dateien
FIREFOX_TAR_DATEI="firefox6.tgz"

SRC_PFAD="$HOME/Programme"

#######################################################################
#                 Einstellungen Ende
#######################################################################


# With Parameter -q we will be quiet (for cron etc)
if [ ${1:-""} = "-q" ]; then
  NOQUIET=false
else
  NOQUIET=true
fi

# wenn firefox noch nicht existiert, dann kopiere es
if [ ! -d $SYD_Dir ]; then
  #cp -R $Quell_Dir $RAM_DISK
  
  cd $RAM_DISK
  tar -xzf ${SRC_PFAD}/${FIREFOX_TAR_DATEI}
  
  $NOQUIET && echo " -> Creating $SYD_Dir..."
  cd $SYD_DIR
  ($SYD_Dir/firefox &)

else

  $NOQUIET && echo " -> gehe zu $SYD_Dir "
  cd $SYD_DIR
  ($SYD_Dir/firefox &)
fi





