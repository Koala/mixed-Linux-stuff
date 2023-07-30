#!/bin/bash
#
# Ziel: Verringerung der Schreibzugriffe auf Festspeichermedium
#
# Diverse Verzeichnisse aus dem Cache und anderen Verzeichnissen werden in 
# einer Ramdisc angelegt und von der bisherige Stelle aus dorthin verlinkt.
#
# 
# Wo soll dieses Script hier abgelegt werden? 
# abgelegen unter: ~/.config/autostart-scripts/
#
# Erstellt und getestet mit Debian Debian 10 (Codename "Buster")

RamDisc="/ramdisc"
TempHome="${RamDisc}/${USER}"

error () {
    echo "Error: $*"
    exit 1
}

if [ ! -d "${RamDisc}" ]; then
    error "${RamDisc} not found."
fi

if [ -d "${TempHome}" ]; then
    rm -r -f -v "${TempHome:?}"
fi

mkdir -p "${TempHome}" || error "Error: cannot mkdir ${TempHome}"
chmod 700 "${TempHome}" || error "Error: cannot chmod 700 ${TempHome}"

cd "${HOME}" || error "Error: cannot change to ${HOME}"

clean_and_link () {
    NewDir="$1"
    if [ -z "${NewDir}" ]; then
        echo "Warning: args not found."
        return
    fi
    # pruefe ob das zu spaeter zu verlinkende Verzeichnis vor dem Loeschen 
    # existiert
#    if [ ! -e "${HOME}/${NewDir}"! ]; then
#        echo "${HOME}/${NewDir} existiert nicht. Verzeichnis ${TempHome}/_TMP_${NewDir} wird nicht erstellt."
#        return
#    fi
    if [ -e "${HOME}/${NewDir}" ]; then
        rm -r -f -v "${HOME:?}/${NewDir}"
    fi
    if [ -e "${TempHome}/_TMP_${NewDir}" ]; then
        rm -r -f -v "${TempHome:?}/_TMP_${NewDir}"
    fi
    mkdir -v -p "${TempHome}/_TMP_${NewDir}" || return
    ln -s -f "${TempHome}/_TMP_${NewDir}" "${NewDir}"
}

# Mozilla Firefox
if [ -d .cache/mozilla ]; then
    for CacheDir in $(find .cache/mozilla -maxdepth 3 -name cache2); do
        if [ -f "${CacheDir}" ]; then
            continue
        fi
        clean_and_link "${CacheDir}"
    done
fi

# thumbnails koennen auch weg 
# Mozilla (oder wer auch immer) kopiert die Dateien aus dem 
# Mozilla-Thumbnails-Verzeichnis auch nach .cache/thumbnails
# Das Verzeichnis wird bereits in die Ramdisc verschoben.
if [ -d .cache/mozilla ]; then
    for CacheDir in $(find .cache/mozilla -maxdepth 3 -name thumbnails); do
        if [ -f "${CacheDir}" ]; then
            continue
        fi
        clean_and_link "${CacheDir}"
    done
fi


# konqueror-Browser-Cache
if [ -d .cache/konqueror ]; then
    for CacheDir in $(find .cache/konqueror -maxdepth 3 -name Cache); do
        if [ -f "${CacheDir}" ]; then
            continue
        fi
        clean_and_link "${CacheDir}"
    done
fi


clean_and_link '.cache/thumbnails'
clean_and_link '.cache/favicons'
clean_and_link '.cache/chromium'
clean_and_link '.cache/vlc'

clean_and_link '.googleearth/Cache'
clean_and_link '.googleearth/Temp'
clean_and_link '.java/deployment/cache'
clean_and_link '.dvdcss'
clean_and_link '.gftp/cache'
clean_and_link '.streamtuner/cache'
#clean_and_link '.vlc/cache'
#clean_and_link '.opera/cache4'
#clean_and_link '.lzncache'
#clean_and_link '.macromedia'


exit 0

# History
#
# 30.07.2023
# - Mozilla legt eigenes thumbnails-Verzeichnis an => weg damit
# - favicons - müssen den Systemstart nicht überleben => weg damit
# - chromium - wird nicht weiter genutzt => weg damit
# - cache des Konqueror => weg damit
# 
#
# 11.04.2021
# - neue Links für den Mozilla-Cache eingearbeitet
# - einiges befindet sich unter ~/.cache
#   Links entsprechend angepasst

# ToDo:
#
# - clean_and_link () - Verzeichnisse werden nicht erstellt, wenn es sie nicht gibt
#   Das bedarf einer genaueren Überlegung !!!
#   Funktioniert so noch nicht -> deshalb auskommentiert






