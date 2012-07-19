#!/bin/bash
# 
# Die verwendete Basis:
# echo $LANG
# de_DE.UTF-8
# 

if [ $# -eq 0 ]; then
  set -- -h
fi

usage () {
cat <<EOF
Usage: 
$0 [OPTIONS] -a [SOURCE1] -b [SOURCE2] -c [DESTINATION]
$0 -s [DIR]

Wenn [OPTIONS] angegeben ist, wird [DEST] entsprechend der Einstellung komprimiert.  
Die Verzeichnisse [SOURCE1] und [SOURCE2] müssen existieren.
Wenn [DEST] nicht existiert, wird versucht es anzulegen.
[SOURCE1] ist das Quellverzeichnis, aus dem die neueren bzw. geänderten Dateien nach [DEST] kopiert werden.
[SOURCE2] ist das Quellverzeichnis, mit dem [SOURCE1] verglichen wird. Hieraus werden keine Dateien kopiert.

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

#say $PACK
#say $QUIET
#say $SRC1
#say $SRC2
#say $DEST


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
  if [[ ! -d "$DEST" ]]
  then
      #say_error "$DEST ist kein Verzeichnis."
      #exit 1
      erstelle_dest $DEST
  fi

  # pruefe die Komprimierungsart
  if [[ ! -z "$PACK" ]] && ([[ "$PACK" != "TGZ" ]] || [[ "$PACK" != "ZIP" ]]) 
  then
      say_error "$DEST ist keine gültige Komprimierungsmöglichkeit."
      exit 1
  fi

  dosomething

}


# only for tests in development phase
testing()
{
  # pruefe ob am Ende des Pfades ein Slash steht
  # der ist zwingend für die korrekte Verzeichniserstellung
  # Stringlänge:
  l=$(echo ${#DEST})
  l=$(( $l - 1 ))
  
  # letztes Zeichen in DEST?
  slash=$(echo ${DEST:l:1})

  # letztes Zeichen muss ein Slash sein, wenn nicht, erweitere DEST um dieses Zeichen
  if [[ "$slash" != "/" ]]
  then
    DEST=$DEST"/"
  fi
  
  exit 1
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
    DEST=$DEST"/"
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
	
  # v1 neue Version
  #v1=44
	v1="$SRC1"
  # v2 alte Version
  #v2=433
	v2="$SRC2"
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
	    pfadv3=$v3$pfad
	
	    # erzeuge Verzeichnisstrucktur
	    mkdir -p $pfadv3
	    # kopiere Dateien und Subverzeichnisse falls notwendig
	    cp $cp_all $val $pfadv3
	  fi
	
	  #if echo $zeile | grep -q "^Files .* differ$"
	  if echo $zeile | grep -q "^Dateien .* verschieden.$"
	  then
	    val=$(echo $zeile | awk '{print $2}')
	
	    pfad=$(dirname $val)
	
	    # Das Source Verzeichnis am Anfang entfernen
	    pfad=${pfad#$v1}
	    # setzen neuen Pfad zusammen
	    pfadv3=$v3$pfad
	
	    # erzeuge Verzeichnisstrucktur
	    mkdir -p $pfadv3
	
	    # kopiere Dateien
	    cp $val $pfadv3
	  fi
	
	done
	
	statistik $DEST

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
  
  echo 
  
}




diff_copy "$@"


IFS="$IFS_BAK"

exit 0
