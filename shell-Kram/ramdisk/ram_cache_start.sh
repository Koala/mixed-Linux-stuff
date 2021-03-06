#!/bin/bash

RamDisc="/ramdisc"
TempHome="${RamDisc}/${USER}"

error () {
    echo "Error: $*"
    exit 1
}

if [ ! -d "${RamDisc}" ]; then
    error "${RamDisk} not found."
fi

if [ -d "${TempHome}" ]; then
    rm -r -f -v "${TempHome}"
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
    if [ -e "${HOME}/${NewDir}" ]; then
	rm -r -f -v "${HOME}/${NewDir}"
    fi
    if [ -e "${TempHome}/_TMP_${NewDir}" ]; then
	rm -r -f -v "${TempHome}/_TMP_${NewDir}"
    fi
    mkdir -v -p "${TempHome}/_TMP_${NewDir}" || return
    ln -s -f "${TempHome}/_TMP_${NewDir}" "${NewDir}"
}

# Funktioniert nicht immer korrekt.
# See bug: https://bugzilla.mozilla.org/show_bug.cgi?id=320535 and some other more
#if [ -d .mozilla ]; then
#    for CacheDir in `find .mozilla -maxdepth 3 -name Cache`; do
#	if [ -f "${CacheDir}" ]; then
#	    continue
#        fi
#	clean_and_link "${CacheDir}"
#    done
#fi

#clean_and_link '.opera/cache4'
#clean_and_link '.thumbnails'
#clean_and_link '.macromedia'
clean_and_link '.googleearth/Cache'
clean_and_link '.googleearth/Temp'
clean_and_link '.java/deployment/cache'
#clean_and_link '.lzncache'
clean_and_link '.dvdcss'
clean_and_link '.gftp/cache'
clean_and_link '.streamtuner/cache'
clean_and_link '.vlc/cache'


exit 0

# eof
