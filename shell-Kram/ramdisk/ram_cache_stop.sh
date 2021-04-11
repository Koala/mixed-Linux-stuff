#!/bin/bash

RamDisc="/ramdisc"
TempHome="${RamDisc}/${USER}"

error () {
    echo "Error: $*"
    exit 1
}

if [ ! -d "${RamDisc}" ]; then
    error "Error: ${RamDisc} not found."
fi

if [ -d "${TempHome}" ]; then
    rm -r -f -v "${TempHome:?}"
fi

exit 0

# eof
