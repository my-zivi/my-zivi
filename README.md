[![Build Status](https://semaphoreci.com/api/v1/stiftungswo/better-izivi/branches/develop/badge.svg)](https://semaphoreci.com/stiftungswo/better-izivi)
[![Maintainability](https://api.codeclimate.com/v1/badges/27054911086cc6862839/maintainability)](https://codeclimate.com/github/stiftungswo/better-izivi/maintainability)

# SWO iZivi

iZivi ist ein Tool, um Schweizer Zivildienstleistende in einem Einsatzbetrieb zu verwalten.

https://izivi.stiftungswo.ch/

## Aufbau der Applikation

### Fundamentals

| Name             | Verwendung                                            | Informationen / Tutorials                                                                                                                                                      |
| ---------------- | ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Ruby             | Basis für das Backend                                 | [Basis Ruby-Tutorial](https://www.tutorialspoint.com/ruby/)                                                                                                                    |
| Javascript (ES6) | Basis für das Frontend                                | [Basis-Tutorial von Mozilla](https://developer.mozilla.org/de/docs/Learn/Getting_started_with_the_web/JavaScript_basis) <br>[Neue Funktionen in ES6](http://es6-features.org/) |
| Docker           | Software-Virtualisierung, genutzt für die Entwicklung | [Einführung in Docker](https://docs.docker.com/get-started/) <br>[Einführung in docker-compose](https://docs.docker.com/compose/)                                              |
| Git              | Versionsverwaltung                                    | [Einführung in Git](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)                                                                                                 |

### Backend

| Name          | Verwendung                                          | Informationen / Tutorials                                            |
| ------------- | --------------------------------------------------- | -------------------------------------------------------------------- |
| Ruby on Rails | Ruby Web-Framework mit integriertem ORM.            | [Offizielle Dokumentation](https://guides.rubyonrails.org/)          |
| RSpec         | RSpec wird für das Testing von Ruby-Code verwendet. | [RSpec tutorial](https://www.rubyguides.com/2018/07/rspec-tutorial/) |

### Frontend

| Name      | Verwendung                                                                      | Informationen / Tutorials                                                                                                                                                                                                                                                                                                                                                                                                                       |
| --------- | ------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| React     | Javascript View-Library                                                         | [Erforderliche JavaScript-Kenntnisse für React](https://www.robinwieruch.de/javascript-fundamentals-react-requirements/) <br> [Offizielles Tutorial von React (eher oberflächlich und nicht als Einsteiger zu empfehlen!)](https://reactjs.org/docs/getting-started.html) <br> [Detaillierte Einführung in React](https://roadtoreact.com/) <br> [React Lifecycle Cheetsheat](https://gist.github.com/bvaughn/923dffb2cd9504ee440791fade8db5f9) |
| Yarn      | Paketverwaltung und Entwicklungsserver ($yarn run watch)                        | [Yarn vs. NPM](https://www.sitepoint.com/yarn-vs-npm/) <br> [Offizielle Website von Yarn](https://yarnpkg.com/lang/en/)                                                                                                                                                                                                                                                                                                                         |
| Babel     | Bibliothek zur Bereitstellung von JavaScript ES6-Funktionen in älteren Browsern | [Was ist Babel?](http://nicholasjohnson.com/blog/what-is-babel/)                                                                                                                                                                                                                                                                                                                                                                                |
| Webpack   | Bundeling JS, CSS, SASS modules                                                 | [Einführung in Webpack (komplex!)](https://survivejs.com/webpack/foreword/)                                                                                                                                                                                                                                                                                                                                                                     |
| IZI Toast | Snackbar for Error and Feedback                                                 | [Offizielle Webseite](http://izitoast.marcelodolce.com/)                                                                                                                                                                                                                                                                                                                                                                                        |

## Umgebungen / Environments

Es gibt mehrere Umgebungen, welche auf dem SWO server laufen.
We have multiple environments running on the stiftungswo.ch server.

| URL                                      | Type                                                                                                      | Usage                                                                                              |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| https://izivi-api.stiftungswo.ch         | Production (Reflects "[master](https://github.com/stiftungswo/better-izivi/tree/master)" branch)          | This is the live version of the app which is used by Zivis/SWO Employees                           |
| https://izivi-api-develop.stiftungswo.ch | Staging (Reflects "[develop](https://github.com/stiftungswo/better-izivi/tree/develop)" branch)           | This version reflects the latest development progress and can be used to show new features or test |
| https://izivi-api-test.stiftungswo.ch    | Testing (Reflects no branch specifically. Can only be deployed by pushing to the bare testing repository) | This version is used to test features/code, which is not yet ready to release to staging.          |

Die production sowie die staging Umgebung werden ausschliesslich durch ein automatisches Deployment, welches Semaphore macht, released.

Einzig die testing Umgebung muss manuell released werden.

### Komponenten

#### Profil

Zivis können Ihre Informationen über den Menupunkt „Profil“ anpassen. Admins können alle Profile anpassen (Menupunkt „Mitarbeiterliste“) und haben zusätzlich die Möglichkeit, interne Bemerkungen zu schreiben und Benutzerrollen anzupassen.

#### Service

Hier werden alle Einsätze aufgeführt, die einem Pflichtenheft sowie einem Zivi zugeteilt wurden.

Es gibt zusätzlich die Service Overview, in welcher man pro Jahr sehen kann, welche Zivis wann einen Einsatz haben.

#### ExpenseSheet

Das ExpenseSheet sind die Spesenblätter. Anhand der geleisteten Tage, Ferien etc. werden die fälligen Spesen pro Monat gerechnet. Die Spesenblätter kann jeder Zivi in seinem Profil anschauen sowie den Stand der Bearbeitung.

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
4. `cd better-izivi/api/`
5. `rbenv install`
6. `gem install bundler`

#### Docker

Installation gemäss der Installationsanleitung auf der [Website](https://docs.docker.com/install/) durchführen. Wichtig: Für manche Betriebssysteme muss docker-compose noch separat installiert werden.

### Backend

1. Ins Verzeichnis des betterIzivi wechseln (z.B. cd ``~/src/swo/better-izivi/api``)
2. Die .env-Datei kopieren `cp .env.example .env`
3. Die .env-Datei ausfüllen
4. `bin/setup` ausführen, oder falls ein Docker container zur Entwicklung verwendet wird: `docker run -it [docker-container-name] api/bin/setup` 
5. Die API ist nun unter `localhost:28000` erreichbar.

## Entwicklung

### RubyMine

RubyMine ist eine IDE für Ruby von Jetbrains. Will man mit RubyMine im Docker entwickeln und testen, muss jedoch noch einiges konfiguriert werden:

1. In RubyMine: `Preferences > Languages & Frameworks > Ruby SDK and Gems` eine neue Remote SDK hinzufügen (`+ > New remote...`) 
2. `Docker Compose` auswählen
3. Bei `Configuration file` die Semaphore-Docker-Compose-Datei auswählen (`better-izivi/docker-compose.semaphore.yaml`)
4. Die `system environment variables` (Icon rechts bei `Environment variables`) deaktivieren

Nun kann man direkt in RubyMine die API starten und beenden. (Über `Edit run configurations` das Port-Mapping anpassen)

### Code-Formatierung

Das Backend und Frontend sollen immer sauber formatiert sein (wird von der CI überprüft).

Vor dem Commiten sollten immer die Formatier-Tools ausgeführt werden.

* Backend: `docker-compose exec api rubocop -a` oder `bundle exec rubocop -a`, falls nativ entwicklet wird
* Frontend: `docker-compose exec frontend yarn format`, bzw. nur `yarn run format`

Für das Backend kommt [rubocop](https://github.com/rubocop-hq/rubocop) zum Einsatz und für das Frontend übernimmt [TSLint](https://palantir.github.io/tslint/) den Job.

#WIP ab hier

### Deployment

Semaphore kann das Projekt zu einem beliebigen remote host deployen. Für das deployment auf dem swo server wird das hauseigene [server-apps](https://github.com/stiftungswo/server-apps) verwendet.

### Sentry

Fehler auf Produktivsystemen werden auf Sentry geloggt wenn eine valide  `SENTRY_DSN` gesetzt ist. Siehe [Config](https://github.com/stiftungswo/izivi/blob/ts/api/.env.example)

Die Variablen werden im Travis Build abgefüllt.

### Deployment at SWO

Weitere Informationen im [privaten Wiki]
(https://wiki.stiftungswo.ch/it:sw:izivi#deployment)

## Nice-to-Know

### Backend

#### Logging

Um Logs auszugeben, kann der Rails Logger verwendet werden (z.B. `Rails.logger.info "Your message"`). Die Logs werden nach `api/logs/` geschrieben. Dieser Ordner wird zwischen dem Docker Container und deiner lokalen Maschine synchronisiert.

#### Database Abstraction Layer

Das Projekt enthält das standardmässige ActiveRecord ORM. Mehr infos unter [https://www.rubydoc.info/gems/activerecord](https://www.rubydoc.info/gems/activerecord)

#### Manuelles Live-Deployment

1. Korrektes remote auf dem lokalen System hinzufügen: bspw. `git remote add metanet-test swo@stiftungswo.ch:~/git/better-izivi/test.git`
2. `git push -f metanet-test [DEIN BRANCH, DER DEPLOYED WERDEN SOLL]:master` ausführen.

**Achtung**: MASTER (izivi.stiftungswo.ch) UND DEVELOP (izivi-develop.stiftungswo.ch) SOLLTEN NIE MANUELL DEPLOYED WERDEN. BEIDE APPLIKATIONEN WERDEN DEPLOYED, IN DEM MAN EINEN PULL REQUEST IN DAS JEWEILIGE ENVIRONMENT MERGED UND SEMAPHORE DIES DANN AUTOMATISCH DEPLOYED.

**Nur iZivi testing (izivi-test.stiftungswo.ch) sollte manuell deployed werden!**

Wenn das deployment erfolgreich war, kommt eine Slack message in dem entsprechenden Channel (#better-izivi).

### Frontend

#### Ladezeiten ermitteln

Seit React 16.5 gibt es einen Profiler, mit welchem die Ladezeiten der einzelnen Komponenten angezeigt werden kann. Dazu die [React Dev-Tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi) in Chrome installieren und die Chrome-Konsole öffnen. Zum React-Tab wechseln, dort auf "Profiler" klicken und auf den Record-Button drücken. 

Anschliessend kann die Seite neu geladen werden und der Record-Button erneut gedrückt werden, um die Aufzeichnung zu beenden. nun hat man eine detaillierte Ansicht aller Ladezeiten der Komponenten.

## License

iZivi is licensed under the GNU General Public License v3.0 (GPLv3). [LICENSE](LICENSE)
