#!/bin/sh
#
# Log Script
#
# diverse Dinge können protokolliert werden
#
# 26.04.2008
#


######
# definiere Variablen
######
DATE=`date +%y%m%d`

# Pfad zur Logdatei
LOG_PFAD="protokoll_$DATE.log"

echo " = B = E = G = I = N = " > $LOG_PFAD


# top im Batch mode
top -b -n 1 >> $LOG_PFAD
echo " =============== " >> $LOG_PFAD


# pstree
pstree >> $LOG_PFAD
echo " =============== " >> $LOG_PFAD


echo " = E = N = D = E = " >> $LOG_PFAD

exit 0



