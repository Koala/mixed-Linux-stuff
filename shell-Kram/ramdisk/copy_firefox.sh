#!/bin/sh
#
# Pruefe ob das Verzeichnis firefox in der Ramdisk vorhanden ist.
# Wenn nicht, dann kopiere es und starte firefox.
# Wenn doch, dann starte firefox.
#

#######################################################################
#                 Einstellungen Anfang
#######################################################################

# Name der gepackten Firefox-Datei ohne ".tgz"
# Nur diese Angabe muss bei jeder neuen Version angepasst werden.
FIREFOXVERSION=firefox13

# Pfad zur RAM-Disk
RAM_DISK=/ramdisc

# Pfad zum Verzeichnis in dem sich Firefox befindet
SRC_PFAD="$HOME/Programme"

#######################################################################
#                 Einstellungen Ende
#######################################################################


# Directory for saving data
SYD_Dir=$RAM_DISK/$FIREFOXVERSION



# With Parameter -q we will be quiet (for cron etc)
if [ ${1:-""} = "-q" ]; then
  NOQUIET=false
else
  NOQUIET=true
fi

# wenn firefox noch nicht existiert, dann kopiere es
if [ ! -d $SYD_Dir ]; then
  
  cd $RAM_DISK
  tar -xzf $SRC_PFAD/$FIREFOXVERSION.tgz
  
  $NOQUIET && echo " -> Creating $SYD_Dir..."
  cd $SYD_DIR
  ($SYD_Dir/firefox &)
else
  $NOQUIET && echo " -> gehe zu $SYD_Dir "
  cd $SYD_DIR
  ($SYD_Dir/firefox &)
fi




