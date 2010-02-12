####################################################################################
####                       Clock Version 0.13
####                 Uhrzeit im Fernsehbild anzeigen
####
####                    Bugreport und Anregungen im Board:
####       http://www.dbox2-tuning.net/forum/viewforum.php?f=27&start=0
####      Das New-Tuxwetter-Team: SnowHead, Worschter, Seddi, Sanguiniker
####################################################################################

Dieses Plugin blendet die Uhrzeit in das laufende Fernsehbild ein. Das ist zunächst erst
einmal eine Testversion. Durch Verzicht auf farbige Darstellung beeinflußt das Plugin
bereits angezeigte Menüs nicht in deren Farbdarstellung.

Funktion und Installation:
--------------------------
Das eigentlich aktive Plugin ist die Datei "clock". Sie kommt mit den Rechten 755 nach
/var/bin/. Um die Uhrzeit anzuzeigen, wird clock über die Kommandozeile (optional mit 
Parametern) gestartet. Zum Beenden von clock muß in /tmp/ die Datei .clock_kill erzeugt 
werden. Vor dem Beenden löscht clock noch den verwendeten Anzeigebereich. Das Starten 
und Beenden von clock kann entweder über das Menü der blauen Taste oder über das Flex-
Menü erfolgen. Für beide Varianten sind die entsprechenden Unterverzeichnisse mit allen 
benötigten Dateien im Archiv vorhanden.
Wer die Art der Anzeige noch konfigurieren möchte, kann zusätzlich die Datei clock.conf
nach /var/tuxbox/config/ kopieren. Deren Einträge haben folgende Bedeutung:

  X= legt die horizontale Position der linken unteren Ecke des Anzeigefeldes fest. Die
     Werte können im Bereich von 0 bis 540 liegen. (0 ist ganz links)

  Y= legt die vertikale Position der Oberkante des Anzeigefeldes fest. Die Werte können
     im Bereich von 0 bis 500 liegen. (0 ist ganz oben)

  DATE= Steht hier eine 1, wird unterhalb der Uhrzeit noch das Datum mit angezeigt. Bei
        0 wird nur die Uhrzeit angezeigt

  BIG= Wer die Anzeige gern größer haben möchte, trägt hier eine 1 ein. Aber bitte dann
       auch die Anzeigepositionen anpassen, damit die Anzeige noch auf den Bildschirm passt.

  SEC= Legt fest, ob die Sekunden in der Uhrzeit angezeigt werden sollen. Bei 1 werden die
       Sekunden angezeigt, bei 0 nicht. Werden die Sekunden nicht angezeigt, blinkt statt
       dessen der Doppelpunkt zwischen Stunden und Minuten

  FCOL= Legt die Ziffernfarbe fest, 0=Transparent, 1=Schwarz, 2=Weiss

  BCOL= Legt die Hintergrundfarbe fest, 0=Transparent, 1=Schwarz, 2=Weiss

  MAIL= legt fest, ob die von Tuxmail erzeugte Benachrichtigung über neue Mails ausgewertet
        und angezeigt werden soll, in diesem Fall blinkt in der Anzeige das Mailsymbol im
        Wechsel mit der Anzahl der neuen Mails

Für den Start über Kommandozeile können diese Parameter in der gleichen Syntax auch als
Kommandozeilenparameter übergeben werden. Eventuell vorher aus der clock.conf ausgelesene
Werte werden dabei von den Kommandozeilenparametern überstimmt. Zum Beispiel:

  /var/bin/clock X=540 Y=0 DATE=1 BIG=1 SEC=0

Es müssen nicht alle Parameter über Kommandozeile eingegeben werden. Nicht in der Kommando-
zeile übergebene oder fehlerhafte Kommandozeilen-Parameter werden zunächst aus der clock.conf 
übernommen oder, wenn diese nicht existiert, mit Defaultwerten vorbelegt. Diese Defaultwerte
sind: X=540, Y=0, DATE=0, BIG=0, SEC=1, FCOL=2, BCOL=1

Steuerung über FlexMenü:
------------------------
Die Datei clock mit den Rechten 755 nach /var/bin/ kopieren und den Text aus der Datei
"einfuegen in shellexec.conf" in die Datei /var/tuxbox/pluhins/shellexec.conf einfügen.
Dabei eine Unix-konformen Editor verwenden. Fertig.

Steuerung über blaue Taste
--------------------------
Die Datei clock mit den Rechten 755 nach /var/bin/ kopieren, clock.cfg und clock.so nach
/var/tuxbox/plugins/. clock.so mit den Rechten 755. Das Script sclock kommt mit den Rech-
ten 755 nach /var/plugins/. Anschließend Box neu starten.
Der erste Aufruf des Menüeintrages "Uhrzeit" startet bei Bedarf clock und zeigt die Uhr
an. Jeder weitere Aufruf schaltet zwischen Anzeigen und Verbergen der Uhrzeit hin und her.

Konfiguration über FlexMenü
---------------------------
Wer die Einstellungen für die Uhrzeit-Anzeige über das FlexMenü machen möchte, findet die
dafür benötigten Dateien in diesem Unterverzeichnis. Die notwendigen Ergänzungen für die
shellexec.conf müssen übernommen und das Script "cops" mit den Rechten 755 nach /var/plugins/
kopiert werden. Wer den Editor "input" noch nicht in seinem Image hat, findet auch diesen im
Archiv. Er kommt mit den Rechten 755 nach /var/bin.

Screensaver
-----------
Auf der Basis des Clock-Plugins liegt noch ein kleines Spielzeug mit bei, der Screensaver
"ssaver". Wird er gestartet (was übrigens mit den gleichen Kommandozeilenoptionen wie bei
"clock" geschehen kann), bewegt sich die Uhrzeitanzeige regellos auf dem Bildschirm. Dabei
wird der gesamte Bildschirm in der Hintergrundfarbe gefüllt und nicht nur der Bereich unter
den Zahlen. Start- und Konfigurationsmöglichkeiten sind gleich denen des Clock-Plugins. Alle
benötigten Dateien liegen dem Archiv bei. Die Eingabe von X- oder Y-Position macht beim Screen-
saver keinen Sinn und wird daher sowohl auf der Kommandozeile als auch in der ssaver.conf ig-
noriert. Der zusätzliche Parameter "SLOW=" steuert die Geschwindigkeit. Zulässig sind Werte
von 0..10. Je höher die Zahl, desto langsamer bewegt sich die Anzeige über den Schirm.
Beendet wird der Screensaver entweder durch Anlegen der Datei "/tmp/.ssaver_kill" oder durch
Drücken einer beliebigen Taste auf der Fernbedienung.

Also, viel Spaß und viel Erfolg

Das New-Tuxwetter-Team
SnowHead und Worschter
