# :robot: Was macht es?

Kurz gesagt, ein Backup einiger Systemeinstellungen bzw. des aktuellen Systemzustandes.

# :mag: Wofür ist das gut?

Im Falle einer Systemwiederherstellung können diese Daten als Grundlage zur Wiederherstellung dienen.
Mit den von `dpkg` und `debconf-get-selections` gesicherten Daten, läßt sich ein System Softwareseitig sehr schnell wieder auf den Zustand zum Zeitpunkt der Speicherung wiederherstellen.

# :eye: Wie nutzen?

- Datei speichern
- Einstellungen anpassen
- ausführbar machen
- als Root starten

# :hammer_and_wrench: Einstellungen

**Directory for saving data:** 
`SYD_DIR="/var/local/saveyourdeb"`

**Location of tar archive from above directory:**
`SYD_TGZ="/var/local"`

**Archiv name:**
`ARC_NAME="saveyourdeb-$(hostname)_$DATE.tar.bz2"`


***Hinweis***
Ich kopiere das Archive direkt zusätzlich an einen anderen Platz. Wenn das nicht gewünscht wird, muss der untere Teil im Script entsprechend gelöscht werden oder auskommentiert oder was auch immer.

**entgueltiges Backupdir:**
`BAK_DIR="/adaten/Backup/debian/saveyourdeb"`

# :point_right: Wichtiger Hinweis

1. das Script funktioniert auf einem Debian-System, wird sicher auch auf anderen laufen ... evtl. sind Anpassungen notwendig

2. Hier wird der `mbr` ausgelesen. Falls die Partitionstabelle auf einer Platte größer als 2TB liegt, wird sehr wahrscheinlich eine **GPT** *(GUID Partition Table)* existieren. Das muss dann enstprechend angepasst werden.


# :copyright: Der Originalhinweis
*(steht auch so in der Datei)*

    Written by Gerhard Brauer <gerhard.brauer@web.de> 2007
    after a discussion in debian-user-german. Thanks to all who
    gave a response/comment and to all on this mailing list who
    impart their knowledge there.

    Backup important files and settings from your debian system.

    Disclaimer: This script is NOT a replacement for a real backup
                of your system! See it as a reserve magazine when
                you draw in the battle of restoring.

    Hint: If you do a really backup of your system you don't need this!
    Hint: Install debconf-utils for full use.

    You:  Edit SYD_Dir, SYD_TGZ and hd_with_mbr to your local conditions.
    You:  you must be root to have access to all needed data.

