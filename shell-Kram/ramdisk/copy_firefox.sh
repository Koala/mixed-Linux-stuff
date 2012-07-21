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
FIREFOXVERSION="firefox13"

# Pfad zur RAM-Disk
RAM_DISK="/ramdisc"

# Pfad zum Verzeichnis in dem sich Firefox befindet
SRC_PFAD="$HOME/Programme"

#######################################################################
#                 Einstellungen Ende
#######################################################################

NOQUIET=

# Directory for saving data
SYD_Dir=$RAM_DISK/$FIREFOXVERSION

# Funktion zur Verzeichniserstellung
# @see ram_cache_start.sh
TempHome="${RAM_DISK}/${USER}"
clean_and_link () 
{
  if [ ! $NOQUIET ]; then
    V_AUSGABE="-v"
  else
    V_AUSGABE=""
  fi
  
  NewDir="$1"
  if [ -z "${NewDir}" ]; then
    echo "Warning: args not found."
    return
  fi
  if [ -e "${HOME}/${NewDir}" ]; then
    rm -r -f $V_AUSGABE "${HOME}/${NewDir}"
  fi
  if [ -e "${TempHome}/_TMP_${NewDir}" ]; then
    rm -r -f $V_AUSGABE "${TempHome}/_TMP_${NewDir}"
  fi
  mkdir $V_AUSGABE -p "${TempHome}/_TMP_${NewDir}" || return
  ln -s -f "${TempHome}/_TMP_${NewDir}" "${NewDir}"
}




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

# warte bis Firefox gestartet ist
# TODO besser ist es den Prozess abzufragen?
sleep 5

# erstelle Cache-Verzeichnis in RAM_DISK und setze Link dorthin
if [ -d .mozilla ]; then
    for CacheDir in `find .mozilla -maxdepth 3 -name Cache`; do
      clean_and_link "${CacheDir}"
    done
fi

