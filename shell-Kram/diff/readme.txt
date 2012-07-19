19.07.2012

[TODO]
Funktion zum automatischen komprimieren des Zielverzeichnisses muss noch fertig werden.


diff-copy kopiert alle unterschiedlichen Verzeichnisse und Dateien aus dem Verzeichnisvergleich in ein neues Verzeichnis.

Basierend auf deutscher Konsolenausgabe. Die Ausgabe kann je nach diff-Version und Übersetzung auch anders aussehen.
Daher gilt, dass die Auswertung der diff-Rückgabe entsprechend angepasst werden muss.
Evtl. könnte das auch noch etwas universeller gestaltet werden.



Usage: 
./diff-copy_de.sh [OPTIONS] -a [SOURCE1] -b [SOURCE2] -c [DESTINATION]
./diff-copy_de.sh -s [DIR]

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







 