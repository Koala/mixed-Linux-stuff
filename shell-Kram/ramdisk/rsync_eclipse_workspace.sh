#!/bin/bash
#
# Version: 1.0 - 11.09.2011
#
# http://linuxwiki.de/rsync
# Wenn die Quelle als letztes Zeichen einen Slash (/) enthält, kopiert rsync dieses Verzeichnis selbst nicht mit, sondern nur die darin enthaltenen Objekte.
# 
# rsync -av /test/mp3/ /mp3
# 
# kopiert den Inhalt von /test/mp3 in /mp3.
#
# Der Befehl 
#   rsync -av /test/mp3 /mp3
# würde das Verzeichnis /mp3/mp3 anlegen und dorthin kopieren. 

# Quellverzeichnis
SRC_DIR="/ramdisc/eclipse_workspace_generall/"

SRC_DIR_TAR="eclipse_workspace_generall/"


# Zielverzeichnis-Basis
DST_DIR_BASIS="${HOME}/Programmierung/"

# Zielverzeichnis fuer Sync
DST_DIR="${DST_DIR_BASIS}eclipse_workspace_generall"

# Pfad und Name der neue zu packenden Datei
DST_TGZ="${DST_DIR_BASIS}eclipse_workspace_generall.tgz"



# With Parameter -q we will be quiet (for cron etc)
if [ ${1:-""} = "-q" ]; then
  NOQUIET=false
else
  NOQUIET=true
fi

# nur wenn das Quellverzeichnis existiert, dann mache einen Sync
if [ -d "${SRC_DIR}" ]; then
  $NOQUIET && echo " -> Starte Sync von $SRC_DIR nach $DST_DIR "
  rsync -ar --update --delete $SRC_DIR $DST_DIR
fi


if [ -d "${SRC_DIR}" ] && [ -e "${DST_TGZ}" ]; then
  $NOQUIET && echo " -> loesche komprimierte alte Datei $DST_TGZ"
  rm "${DST_TGZ}" 2>/dev/null
fi

if [ -d "${SRC_DIR}" ] && [ ! -e "${DST_TGZ}" ]; then
  # erstelle ein neues Archiv
  $NOQUIET && echo " -> erstelle neues Archiv $DST_TGZ"
  cd "${SRC_DIR}"
  cd ..
  tar czf $DST_TGZ $SRC_DIR_TAR 
  # 2>/dev/null
fi

echo " = = = > > FERTIG "








exit 0
