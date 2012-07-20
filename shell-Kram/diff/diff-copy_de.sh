#!/bin/bash
# diff-copy_de.sh
# Copyright (C) [2012]  [Koala]
#
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
# 
# Version: 0.2
#   Datum: 20.07.2012
#   Autor: Koala (https://github.com/Koala)
#  Lizenz: GPL
#
#
# Die verwendete Basis:
# echo $LANG
# de_DE.UTF-8
# 

# wurde kein Argument beim Aufruf übergeben, dann soll die Hilfe aufgerufen werden
if [ $# -eq 0 ]; then
  set -- -h
fi

usage () {
cat <<EOF
Usage: 
$0 [OPTIONS] -a [SOURCE1] -b [SOURCE2] -c [DESTINATION]
$0 -s [DIR]

Wenn -p angegeben ist, wird [DEST] entsprechend der Einstellung komprimiert.  
Die Verzeichnisse [SOURCE1] und [SOURCE2] müssen existieren.
Wenn [DEST] nicht existiert, wird versucht es anzulegen.
[SOURCE1] ist das Quellverzeichnis, aus dem die neueren bzw. geänderten Dateien nach [DEST] kopiert werden.
[SOURCE2] ist das Quellverzeichnis, mit dem [SOURCE1] verglichen wird. Hieraus werden keine Dateien kopiert.

Wenn Verzeichnisnamen Leerzeichen enthalten, so müssen diese evtl. in Anführungsstriche geschrieben werden.
$0 -p TGZ -a "Ver zeichnis1/" -b "Verzei chnis2" -c "ich existiere noch nicht"

Die Statistik-Option "-s" ist nicht mit anderen Optionen kombinierbar. 

Options:
  -a  Source 1
  -b  Source 2
  -c  Destination
  -p  TGZ oder ZIP - erstelle entsprechendes Archiv aus [DEST] 
  -q  Quiet Mode / keinerlei Ausgaben (bis auf Fehlermeldungen)

  -s  [DIR] gibt eine Statistik für das angegebene Verzeichnis aus
  -h  diese kleine Hilfe hier

EOF
exit 1
}

QUIET=
PACK=   # kann TGZ oder ZIP sein
SRC1=   # muss ein Verzeichnis sein
SRC2=   # muss ein Verzeichnis sein
DEST=   # muss ein Verzeichnis sein


# init
diff_copy()
{


  while [ $# -gt 0 ]; do
		opt="$1"
		shift
		case "$opt" in
			-q) QUIET=1 ;;
			-p) PACK="$1"; shift;;
      -a) SRC1="$1"; shift;;
      -b) SRC2="$1"; shift;;
      -c) DEST="$1"; shift;;
      -s) statistik "$1"; exit 0 ;;
      -t) testing; exit 0 ;; # only for tests in development phase
      -h) usage;;
			*) say "Unexpected option: $opt"; exit 1 ;;
		esac
	done


  # pruefe ob zumindest die notwendigen Verzeichnisargumente uebergeben wurden
	if [[ -z "$SRC1" ]] || [[ -z "$SRC2" ]] || [[ -z "$DEST" ]]
	then
	    say_error "Eines der drei notwendigen Verzeichnisse fehlt."
	    exit 1
	fi

  # pruefe, ob es sich um Verzeichnisse handelt
  if [[ ! -d "$SRC1" ]]
  then
      say_error "$SRC1 ist kein Verzeichnis."
      exit 1
  fi
    
  if [[ ! -d "$SRC2" ]]
  then
      say_error "$SRC2 ist kein Verzeichnis."
      exit 1
  fi

  # wenn DEST nicht existiert, versuche es anzulegen
  plusslash
  if [[ ! -d "$DEST" ]]
  then
      erstelle_dest "$DEST"
  fi

	error_pack_tgz=0
	error_pack_zip=0
  # pruefe die Komprimierungsart
  #if [ ! -z "$PACK" ] && ( [ "$PACK" != "TGZ" ] || [ "$PACK" != "ZIP" ] ) # funktioniert nicht ??? 
  if [ ! -z "$PACK" ] 
    then
      if [ "$PACK" != "TGZ" ]
      then
        error_pack_tgz=1
      fi
      if [ "$PACK" != "ZIP" ]
      then
        error_pack_zip=1
      fi
      if [ $error_pack_tgz -eq 1 ] && [ $error_pack_zip -eq 1 ]
      then
        say_error "\"$PACK\" ist keine gültige Komprimierungsmöglichkeit."
        exit 1
      fi
  fi

  # los gehts
  dosomething

}


# only for tests in development phase
testing()
{
  echo "Nothing to see here :-)"
  exit 0
}
# only for tests in development phase






# Wenn die Ausgabe nicht stumm (quiet) geschalten ist, dann werden hierüber 
# definierte Nachrichten ausgegeben.
# public
say()
{
	if [ -z "$QUIET" ]; then
  	echo "$@" >&2
	fi
}


# Fehlermeldungen werden in besonderem "Rahmen" ausgegeben
# public
say_error()
{
  echo "====== FEHLER ======" >&2
  echo "$@" >&2
  echo "====== FEHLER ======" >&2
  echo "" >&2
}


# erstelle das Zielverzeichnis da es noch nicht existiert
# private
erstelle_dest()
{
  # pruefe ob am Ende des Pfades ein Slash steht
  # der ist zwingend für die korrekte Verzeichniserstellung
  # Stringlänge:
  l=$(echo ${#DEST})
  l=$(( $l - 1 ))
  
  # letztes Zeichen in DEST ist:
  slash=$(echo ${DEST:l:1})

  # letztes Zeichen muss ein Slash sein, wenn nicht, erweitere DEST um dieses Zeichen
  if [[ "$slash" != "/" ]]
  then
    DEST="$DEST""/"
  fi
  
  dirmk=$(mkdir -p "$@")
  if [[ "$dirmk" > 0 ]]
  then
      say_error "$@ konnte nicht erstellt werden."
      exit 1
  fi
}


# die Hauptfunktion zur Differensermittlung
# private
dosomething()
{
	IFS_BAK="$IFS";
  #IFS=$'\n';
	IFS=$'\r\n';
	SRC11=
	SRC22=
  
  ####################################
  # SRC1
  ####################################
  # pruefe ob am Ende des Pfades ein Slash steht
  # der muss weg 
  # Stringlänge:
  l=$(echo ${#SRC1})
  l=$(( $l - 1 ))
  
  # letztes Zeichen in DEST ist:
  slash=$(echo ${SRC1:l:1})

  # letztes Zeichen darf kein Slash sein
  if [[ "$slash" == "/" ]]
  then
    # den Slash am Zeilenende noch entfernen
    SRC11=${SRC1%/}
  fi
  ####################################
  # SRC1
  ####################################
      
  ####################################
  # SRC2
  ####################################
  # pruefe ob am Ende des Pfades ein Slash steht
  # der muss weg 
  # Stringlänge:
  l=$(echo ${#SRC2})
  l=$(( $l - 1 ))
  
  # letztes Zeichen in DEST ist:
  slash=$(echo ${SRC2:l:1})

  # letztes Zeichen darf kein Slash sein
  if [[ "$slash" == "/" ]]
  then
    # den Slash am Zeilenende noch entfernen
    SRC22=${SRC2%/}
  fi
  ####################################
  # SRC2
  ####################################
    
  
  # v1 neue Version
  #v1=44
	v1="$SRC11"
  # v2 alte Version
  #v2=433
	v2="$SRC22"
  # v3 Zielverzeichnis
  #v3=tdiff
	v3="$DEST"

  # lies den kompletten Diff ein
	diffkomplett=$(LANG=C diff -rq $v1 $v2)

	for zeile in $diffkomplett
	do
	  # setze Var auf Null
	  cp_all=
	  pfad=
	  val=
	  pfadv3=
	    
	  #if echo $zeile | grep -q "^Only in $v1:"
	  if echo $zeile | grep -q "^Nur in $v1"
	  then
	    # ersetze ": " durch "/"
	    zeile=${zeile/: /\/}
	    # den Punkt am Zeilenende noch entfernen
	    zeile=${zeile%.}
	
	    # hole den Pfadteil aus der Zeile
	    #val=$(echo $zeile | grep "^Only in $v1:" | awk '{print $3}')
	    val=$(echo $zeile | grep "^Nur in $v1" | awk '{print $3}')
	
	    # wenn es sich nur um ein Directory handelt, dann kopiere alles
	    # was sich darin befindet
	    if [ -d $val ]; then
	      pfad=$val
	      val=$val/*
	      cp_all=-r
	    else 
	      pfad=$(dirname $val)
	    fi
	    # Das Source Verzeichnis am Anfang entfernen
	    pfad=${pfad#$v1}
	    # setzen neuen Pfad zusammen
	    pfadv3="$v3""$pfad"

	    # erzeuge Verzeichnisstrucktur
	    mkdir -p "$pfadv3"
	    # kopiere Dateien und Subverzeichnisse falls notwendig
	    cp $cp_all $val "$pfadv3"
	  fi
	
	  #if echo $zeile | grep -q "^Files .* differ$"
	  if echo $zeile | grep -q "^Dateien .* verschieden.$"
	  then
	    val=$(echo $zeile | awk '{print $2}')
	
	    pfad=$(dirname $val)
	
	    # Das Source Verzeichnis am Anfang entfernen
	    pfad=${pfad#$v1}
	    # setzen neuen Pfad zusammen
	    pfadv3="$v3""$pfad"

	    # erzeuge Verzeichnisstrucktur
	    mkdir -p "$pfadv3"
	
	    # kopiere Dateien
	    cp $val "$pfadv3"
	  fi
	
	done
	
	statistik "$DEST"
	compressing

  IFS="$IFS_BAK"

} # dosomething()


# eine kleine Statistik über die Anzahl Dateien und Verzeichnisse im zu 
# prüfenden Verzeichnis
# public
statistik()
{
  DIR="$@"
  $en
  dateien=$(find $DIR -type f | wc -l)
  if [[ $dateien > 1 ]] 
  then 
    en="en"
  fi
  say "$dateien Datei$en befinden sich im Verzeichnis \"$DIR\"."

  dirs=$(find $DIR -type d | wc -l)
  if [[ $dirs > 1 ]] 
  then 
    en="se"
  fi
  say "$dirs Verzeichnis$en befinden sich im Verzeichnis \"$DIR\" (inkl. dem Verzeichnis selbst)."
}


# komprimiere das DEST-Verzeichnis
# private
compressing()
{
  DIR="$@"
  tars=
  zips=
  packerror=
  DESTPACK=
  
  # pruefe ob am Ende des Pfades ein Slash steht
  # für die zu erstellende komprimierte Datei darf da kein Slash sein 
  # Stringlänge:
  l=$(echo ${#DEST})
  l=$(( $l - 1 ))
  
  # letztes Zeichen in DEST ist:
  slash=$(echo ${DEST:l:1})

  # letztes Zeichen darf kein Slash sein
  if [[ "$slash" == "/" ]]
  then
    # den Slash am Zeilenende noch entfernen
    DESTPACK=${DEST%/}
  fi
  
  if [[ "$PACK" == "TGZ" ]]
  then
    DESTTGZ=$DESTPACK".tgz"
    #packerror=$(tar -czf $DESTTGZ $DEST)
    tar -czf "$DESTTGZ" "$DEST" 2> /dev/null
    packerror=$?
        
    if [[ $packerror -eq 0 ]]
    then
        say "Verzeichnis \"$DEST\" erfolgreich nach \"$DESTTGZ\" komprimiert."
    fi
    if [[ $packerror -eq 1 ]]
    then
        say_error "Es trat ein Fehler beim Erstellen von \"$DESTTGZ\" auf."
        exit 1
    fi
    if [[ $packerror -eq 2 ]]
    then
        say_error "Verzeichnis \"$DEST\" nicht gefunden."
        exit 1
    fi
  fi
  
  
  if [[ "$PACK" == "ZIP" ]]
  then
    DESTZIP=$DESTPACK".zip" # nur für die Meldungsausgabe benötigt
    packerror=$(zip -r -q "$DESTPACK" "$DEST")
    packerrorzip=$?
    if [[ $packerrorzip -eq 0 ]]
    then
        say "Verzeichnis \"$DEST\" erfolgreich nach \"$DESTZIP\" komprimiert."
    fi
        
    if [[ ! $packerrorzip -eq 0 ]] 
    then
        say_error "$DESTPACK.zip konnte nicht erstellt werden. ZIP meldet: $packerror"
        exit 1
    fi
  fi
}

# pruefe ob am Verzeichnis ein Slash dran ist
# wenn nicht, füge eine Slash an
# private
plusslash()
{
  # pruefe ob am Ende des Pfades ein Slash steht
  # der ist zwingend für die korrekte Verzeichniserstellung
  # Stringlänge:
  l=$(echo ${#DEST})
  l=$(( $l - 1 ))
  
  # letztes Zeichen in DEST ist:
  slash=$(echo ${DEST:l:1})

  # letztes Zeichen muss ein Slash sein, wenn nicht, erweitere DEST um dieses Zeichen
  if [[ "$slash" != "/" ]]
  then
    DEST="$DEST""/"
  fi
}


diff_copy "$@"



exit 0
