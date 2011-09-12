#!/bin/bash
#
# Pruefe ob das Verzeichnis Eclipse in der Ramdisk vorhanden ist.
# Wenn nicht, dann kopiere es und starte Eclipse.
# Wenn doch, dann starte Eclipse direkt.
#

#######################################################################
#                 Einstellungen Anfang
#######################################################################

# Pfad zur RAM-Disk
RAM_DISK="/ramdisc"

# Verzeichnis für Eclipse in der Ramdisk
SYD_DIR="${RAM_DISK}/eclipse"

# Verzeichnis für das Arbeitsverzeichnis in der Ramdisk
WORKSPACE_SYD_DIR="${RAM_DISK}/eclipse_workspace_generall"

# Dateien
ECLIPSE_TAR_DATEI="eclipse3.7.tgz"
WORKSPACE_TAR_DATEI="eclipse_workspace_generall.tgz"

SRC_PFAD="$HOME/Programmierung"

#######################################################################
#                 Einstellungen Ende
#######################################################################


# With Parameter -q we will be quiet (for cron etc)
if [ ${1:-""} = "-q" ]; then
  NOQUIET=false
else
  NOQUIET=true
fi

# wenn das Workspace noch nicht existiert, dann kopiere es
if [ ! -d $WORKSPACE_SYD_DIR ]; then
  
  cd $RAM_DISK

  $NOQUIET && echo " -> Entpacke ${WORKSPACE_TAR_DATEI} ..."
  tar -xzf ${SRC_PFAD}/${WORKSPACE_TAR_DATEI}
fi


# wenn eclipse noch nicht existiert, dann kopiere es
if [ ! -d $SYD_DIR ]; then
  #cp -R $Quell_Dir $RAM_DISK
  
  cd $RAM_DISK
  tar -xzf ${SRC_PFAD}/${ECLIPSE_TAR_DATEI}

  $NOQUIET && echo " -> Creating $SYD_DIR..."
  cd $SYD_DIR
  ($SYD_DIR/eclipse &)

else

  $NOQUIET && echo " -> gehe zu $SYD_DIR "
  cd $SYD_DIR
  ($SYD_DIR/eclipse &)

fi




