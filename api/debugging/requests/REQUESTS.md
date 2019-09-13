# Debugging Requests

Die HTTP Requests Files in diesem Ordner können mit einem JetBrains Tool verwendet werden,
wie bspw. [RubyMine](https://www.jetbrains.com/ruby/).

In RubyMine kann man die Datei einfach öffnen und den Request mit dem kleinen grünen Pfeil neben dem HTTP Verb
ausführen. Alternativ auch mit ⌥+return auf Mac.

Um sich einzuloggen gibt es den `authentication/login.http` Request, der automatisch das JWT Token in eine
lokale Variable speichert.

Zudem ist die URL der API als Environment Variable konfiguriert, 
die man in der Datei `http-client.env.json` ändern kann.
