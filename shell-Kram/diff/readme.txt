##############################################################################
diff-copy_de.sh
Copyright (C) [2014]  [Koala]

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
 
Version: 0.2.4
  Datum: 04.05.2014
  Autor: Koala (https://github.com/Koala)
 Lizenz: GPL
##############################################################################


diff-copy kopiert alle unterschiedlichen Verzeichnisse und Dateien aus dem Verzeichnisvergleich in ein neues Verzeichnis.

Basierend auf deutscher Konsolenausgabe. Die Ausgabe kann je nach diff-Version und Übersetzung auch anders aussehen.
Daher gilt, dass die Auswertung der diff-Rückgabe entsprechend angepasst werden muss.
Evtl. könnte das auch noch etwas universeller gestaltet werden.


Usage: 
./diff-copy_de.sh [OPTIONS] -a [SOURCE1] -b [SOURCE2] -c [DESTINATION]
./diff-copy_de.sh -s [DIR]

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


#################
 :: Changelog :: 
#################

[0.2.4]
- MD5SUMME Ausgabe in Konsole und in Datei eingebaut
Momentan ist der Dateiname noch fest im Code hinterlegt.
- Fehler beim kopieren versteckter Dateien behoben


