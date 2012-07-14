#!/bin/bash
# 
# Die verwendete Basis:
# echo $LANG
# de_DE.UTF-8
# 

IFS_BAK="$IFS";
#IFS=$'\n';
IFS=$'\r\n';

# v1 neue Version
v1=44
# v2 alte Version
v2=433
# v3 Zielverzeichnis
v3=tdiff

huhu=$(LANG=C diff -rq $v1 $v2)

for zeile in $huhu
do
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

    # setze Var auf Null
    cp_all=""

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

IFS="$IFS_BAK"

exit 0
