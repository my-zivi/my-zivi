[![Build Status](https://semaphoreci.com/api/v1/stiftungswo/better-izivi/branches/develop/badge.svg)](https://semaphoreci.com/stiftungswo/better-izivi)
[![Maintainability](https://api.codeclimate.com/v1/badges/27054911086cc6862839/maintainability)](https://codeclimate.com/github/stiftungswo/better-izivi/maintainability)

# SWO iZivi #

iZivi ist ein Tool, um Schweizer Zivildienstleistende in einem Einsatzbetrieb zu verwalten.

https://izivi.stiftungswo.ch/

## Inhaltsverzeichnis

## Aufbau der Applikation

### Fundamentals
| Name | Verwendung | Informationen / Tutorials |
| --- | --- | --- |
| Ruby | Basis für das Backend | [Basis Ruby-Tutorial](https://www.tutorialspoint.com/ruby/) |
| Javascript (ES6) | Basis für das Frontend | [Basis-Tutorial von Mozilla](https://developer.mozilla.org/de/docs/Learn/Getting_started_with_the_web/JavaScript_basis) <br>[Neue Funktionen in ES6](http://es6-features.org/) |
| Docker | Software-Virtualisierung, genutzt für die Entwicklung | [Einführung in Docker](https://docs.docker.com/get-started/) <br>[Einführung in docker-compose](https://docs.docker.com/compose/) |
| Git | Versionsverwaltung | [Einführung in Git](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics) |

### Backend

| Name | Verwendung | Informationen / Tutorials |
| --- | --- | --- |
| Ruby on Rails | Ruby Framework zur Datenbank-Abstraktion, MVC-konform. | [Offizielle Dokumentation](https://guides.rubyonrails.org/) |
| RSpec	| RSpec wird für das Testing von Ruby-Code verwendet. | [RSpec tutorial](https://www.rubyguides.com/2018/07/rspec-tutorial/)

### Frontend
| Name | Verwendung | Informationen / Tutorials |
| --- | --- | --- |
| React | Javascript View-Library | [Erforderliche JavaScript-Kenntnisse für React](https://www.robinwieruch.de/javascript-fundamentals-react-requirements/) <br> [Offizielles Tutorial von React (eher oberflächlich und nicht als Einsteiger zu empfehlen!)](https://reactjs.org/docs/getting-started.html) <br> [Detaillierte Einführung in React](https://roadtoreact.com/) <br> [React Lifecycle Cheetsheat](https://gist.github.com/bvaughn/923dffb2cd9504ee440791fade8db5f9) |
| Yarn | Paketverwaltung und Entwicklungsserver ($yarn run watch) | [Yarn vs. NPM](https://www.sitepoint.com/yarn-vs-npm/) <br> [Offizielle Website von Yarn](https://yarnpkg.com/lang/en/) |
| Babel  | Bibliothek zur Bereitstellung von JavaScript ES6-Funktionen in älteren Browsern | [Was ist Babel?](http://nicholasjohnson.com/blog/what-is-babel/) |
| Webpack | Bundeling JS, CSS, SASS modules | [Einführung in Webpack (komplex!)](https://survivejs.com/webpack/foreword/) |
| IZI Toast | Snackbar for Error and Feedback | [Offizielle Webseite](http://izitoast.marcelodolce.com/) |

### Komponenten

#### Profil
Zivis können Ihre Informationen über den Menupunkt „Profil“ anpassen. Admins können alle Profile anpassen (Menupunkt „Mitarbeiterliste“) und haben zusätzlich die Möglichkeit, interne Bemerkungen zu schreiben und Benutzerrollen anzupassen.

#### Mission
Hier werden alle Einsätze aufgeführt, die einem Pflichtenheft sowie einem Zivi zugeteilt wurden.

Es gibt zusätzlich die Mission Overview, in welcher man pro Jahr sehen kann, welche Zivis wann einen Einsatz haben.

#### ReportSheet
Das ReportSheet sind die Spesenblätter. Anhand der geleisteten Tage, Ferien etc. werden die fälligen Spesen pro Monat gerechnet. Die Spesenblätter kann jeder Zivi in seinem Profil anschauen sowie den Stand der Bearbeitung.

#### UserFeedback
Nach dem Einsatz sollen die Zivis jeweils ein Feedback zum Betrieb, den Einsatzleitern und allgemein dem Einsatz bei der SWO abgeben. Diese werden anonym gespeichert und in einer Gesamtauswertung für das Jahr dargestellt. Einsicht hat hier nur der Admin, resp. der Zivi hat Einsicht auf sein eigenes Feedback.

## Installation
### Vorbereitung
#### Homebrew für Mac
Fast jede Linux-Distribution wird mit einem Paketmanager ausgeliefert. Diese ermöglichen dir, bequem neue Programme zu installieren, ohne dazu eine aufwendige Installation durchführen zu müssen. Unter Mac hat die Community homebrew entwickelt, um einen solchen Paketmanager auf Mac bereitzustellen.

Die Installation kann im Terminal mit einem Einzeiler angestossen werden, welcher sich auf der [offiziellen Website](https://brew.sh/index_de) befindet.

#### Ruby
Ruby wird einfacherweise mit [rbenv](https://github.com/rbenv/rbenv) installiert:
1. `brew install rbenv ruby-build`
2. `echo 'eval "$(rbenv init -)"' >> ~/.bash_profile`
3. `source ~/.bash_profile`
4. `cd betterIzivi/api/`
5. `rbenv install`
6. `gem install bundler`

#### Docker
Installation gemäss der Installationsanleitung auf der [Website](https://docs.docker.com/install/) durchführen. Wichtig: Für manche Betriebssysteme muss docker-compose noch separat installiert werden.

#### Installationsskript
[WIP] Die Punkte `Backend` und `Git` können mit `./setup-dev.sh` im iZivi-Verzeichnis automatisch ausgeführt werden.

### Backend
1. Ins Verzeichnis des betterIzivi wechseln (z.B. cd ``~/src/swo/betterIzivi/api``)
2. Die .env-Datei kopieren `cp .env.example .env`
3. Die .env-Datei ausfüllen
4. Docker-Image der API bauen: ``docker-compose up -d --build api``
5. Docker-Stack starten: ``docker-compose up -d``
6. Datenbank importieren:
    - Datenbank bei Metanet als SQL exportieren (Datenbank -> MySQL -> stiftun8_izivi2 -> Backup)
    - PHPMyAdmin öffnen, verfügbar unter `localhost:28080`
    - Einloggen mit Server "mariadb", Benutzername "root", Passwort leer.
    - Neue Datenbank erstellen namens "better_izivi_development" und den Datenbankexport von Metanet importieren.
7. Die API ist nun unter `localhost:28000` erreichbar.


## Entwicklung
### RubyMine
RubyMine ist eine IDE für Ruby von Jetbrains. Will man mit RubyMine im Docker entwickeln und testen, muss jedoch noch einiges konfiguriert werden:
1. In RubyMine: `Preferences > Languages & Frameworks > Ruby SDK and Gems` eine neue Remote SDK hinzufügen (`+ > New remote...`) 
2. `Docker Compose` auswählen
3. Bei `Configuration file` die Semaphore-Docker-Compose-Datei auswählen (`betterIzivi/docker-compose.semaphore.yaml`)
4. Die `system environment variables` (Icon rechts bei `Environment variables`) deaktivieren

Nun kann man direkt in RubyMine die API starten und beenden. (Über `Edit run configurations` das Port-Mapping anpassen)

### Code-Formatierung

Das Backend und Frontend sollen immer sauber formatiert sein (wird von der CI überprüft).

Vor dem Commiten sollten immer die Formatier-Tools ausgeführt werden.

* Backend: `docker-compose exec api rubocop -a`
* Frontend: `docker-compose exec frontend yarn format`

Für das Backend kommt [rubocop](https://github.com/rubocop-hq/rubocop) zum Einsatz und für das Frontend übernimmt [TSLint](https://palantir.github.io/tslint/) den Job.

#WIP ab hier

### Deployment

Semaphore kann das Projekt mit seinem [deploy Skript](https://github.com/stiftungswo/izivi/blob/ts/ci/deploy.sh) per SSH auf einem beliebigen Webhosting automatisch deployen. Dafür müssen auf dem Zielserver unter `~/deploy` folgende Files liegen:

* izivi.prod.env (orientiert sich an [.env.example](https://github.com/stiftungswo/izivi/blob/ts/api/.env.example)

### Sentry

Fehler auf Produktivsystemen werden auf Sentry geloggt wenn eine valide  `SENTRY_DSN` gesetzt ist. Siehe [Config](https://github.com/stiftungswo/izivi/blob/ts/api/.env.example)

Die Variablen werden im Travis Build abgefüllt.

### Deployment at SWO

Weitere Informationen im [privaten Wiki]
(https://wiki.stiftungswo.ch/it:sw:izivi#deployment)

## Nice-to-Know
### Backend
#### Logging
Um Logs auszugeben, kann der Lumen Logger verwendet werden (z.B. `\Log::warning("your message here.");`). Die Dokumentation mit mehr Informationen befindet sich [hier](https://lumen.laravel.com/docs/5.2/errors). Die Logs werden nach `api/storage/logs/` geschrieben. Dieser Ordner wird zwischen dem Docker Container und deiner lokalen Maschine synchronisiert.

#### Database Abstraction Layer
Das Projekt enthält den standardmässigen Lumen DBAL als auch Doctrine. Grund dafür ist, dass für die Modifikation von bestehenden Tabellenspalten, welche bereits Daten enthalten, dies [benötigt](https://laravel.com/docs/5.6/migrations#modifying-columns) wird.

#### Manuelles Live-Deployment
1. Alle Dateien (ausser den vendor-Ordner) auf den Server kopieren
2. Neue .env-Datei erstellen (oder Beispiel kopieren) und für den Server anpassen. Wichtig: APP_ENV auf "production" setzen und DEBUG auf "false".
3. Auf den Server via SSH verbinden.
4. [Composer installieren](https://getcomposer.org/download/) und Pakete mit ``php composer.phar install`` installieren.
5. Falls Migrationen erzeugt wurden, diese via ``php artisan migrate`` ausführen.
6. Sicherstellen, dass die Apache-Konfiguration auf den public folder zeigt.

### Frontend
#### Manuelles Live-Deployment
1. "BASE_URL" in src/utils/api.js anpassen.
2. ``yarn build`` auf der lokalen Maschine ausführen.
3. Alle Dateien auf dem Server löschen und neue Dateien kopieren.
4. Sicherstellen, dass eine .htaccess-Datei mit folgendem Inhalt existiert.
```
Options -MultiViews
RewriteEngine On
RewriteCond %{HTTPS} =off
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [QSA,L,R=301]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^ index.html [QSA,L]
```

#### Ladezeiten ermitteln
Seit React 16.5 gibt es einen Profiler, mit welchem die Ladezeiten der einzelnen Komponenten angezeigt werden kann. Dazu die [React Dev-Tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi) in Chrome installieren und die Chrome-Konsole öffnen. Zum React-Tab wechseln, dort auf "Profiler" klicken und auf den Record-Button drücken. 

Anschliessend kann die Seite neu geladen werden und der Record-Button erneut gedrückt werden, um die Aufzeichnung zu beenden. nun hat man eine detaillierte Ansicht aller Ladezeiten der Komponenten.

## License

iZivi is licensed under the GNU General Public License v3.0 (GPLv3). [LICENSE](LICENSE)
