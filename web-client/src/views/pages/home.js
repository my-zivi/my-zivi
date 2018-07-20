import Card from '../tags/card';
import Header from '../tags/header';

export default function(props) {
  return (
    <Header>
      <div className="page page__home">
        <Card>
          <h1>
            iZivi <span> ist ein Tool der SWO zur Erfassung und Planung von Zivi-Einsätzen</span>
          </h1>
          <br />

          <p>
            Bist du das erste mal bei uns und möchtest einen Einsatz planen? Dann kannst du dich über folgenden Link{' '}
            <a href="//izivi.stiftungswo.ch/register" target="_self">
              Registrieren
            </a>.
          </p>
          <p>
            Falls du uns bereits bekannt bist, kannst du dich hier{' '}
            <a href="//izivi.stiftungswo.ch/login" target="_self">
              Anmelden
            </a>.
          </p>
        </Card>
        <Card>
          <h2>Ablauf der Planung eines Einsatzes</h2>
          <p>
            Als zukünftiger Zivi musst du dich zuerst erkundigen, ob zum gewünschten Zeitpunkt ein Einsatz möglich ist. Kontaktiere hierfür
            bitte direkt{' '}
            <a href="//stiftungswo.ch/about/meet-the-team#jumptomarc" target="_blank">
              {' '}
              Marc Pfeuti{' '}
            </a>
            unter{' '}
            <a
              href="mailto:mp@stiftungswo.ch?subject=Einsatzplanung Zivildienst&body=Guten Tag Herr Pfeuti! 
              %0D%0A%0D%0AIch schreibe Ihnen betreffend meiner Einsatzplanung als FELDZIVI / BÜROZIVI (EINS AUSWÄHLEN) vom DD.MM.YYYY bis DD.MM.YYYY, wäre dieser Zeitraum möglich?
              %0D%0A%0D%0A
              %0D%0A%0D%0ABesten Dank und freundliche Grüsse"
            >
              {' '}
              mp@stiftungswo.ch{' '}
            </a>.
          </p>
          <ul type="circle">
            <li>
              Ist ein Einsatz grundsätzlich möglich, wirst du im allgemeinen einen halben Schnuppertag absolvieren müssen. Hat dir der
              Schnuppertag gefallen und die Einsatzleitung ist mit deiner Motivation & Leistung zufrieden, so wird dir ein Community
              Passwort bekannt gegeben, mit welchem du dir auf dieser Seite deinen Account eröffnen und die Einsatzplanung erstellen kannst.
            </li>
            <li>
              Nach Eingabe deiner persönlichen Daten kannst du die Einsatzplanung ausdrucken, unterschreiben und an den Einsatzbetrieb
              zurückzuschicken. Nach erfolgreicher Prüfung werden wir diese direkt an dein zuständiges Regionalzentrum weiterleiten.
            </li>
            <li>Das Aufgebot erhältst du dann automatisch von deinem zuständigen Regionalzentrum.</li>
          </ul>
        </Card>
        <Card>
          <h2>Account erstellen</h2>
          <p>Für einen Account werden folgende Daten benötigt:</p>
          <ul>
            <li>
              Zivildienst Nummer (ZDP): Dies wird dein zukünftiger Benutzername sein, mit welchem du dich jederzeit wieder auf dieser Seite
              einloggen kannst.
            </li>
            <li>Vorname, Nachname: Werden in der Menüleiste angezeigt, wenn du eingeloggt bist.</li>
            <li>Email: Wird benützt um Nachrichten vom System zu senden.</li>
            <li>Persönliches Passwort und Bestätigung : Ein frei wählbares Passwort. Mit diesem wirst du dich in Zukunft einloggen.</li>
            <li>
              Community Passwort: Mit diesem Passwort identifiziert dich das System als berechtigt einen Account zu eröffnen. Es wird dir
              von der Einsatzleitung bekannt gegeben.
            </li>
          </ul>
        </Card>
        <Card>
          <h2>Persönliche Daten eingeben</h2>
          <p>
            Auf dieser Seite kannst du deine persönlichen Daten erfassen und editieren. Primär werden diese zur Erstellung der
            Einsatzplanung benötigt. Einige andere sind uns bei der Administration des Zivi Projektes (Bsp. KontoNr.) hilfreich. Bitte fülle
            alle Felder korrekt aus. Du erleichterst uns und dir deinen Zivieinsatz. Zu folgenden Feldern einige Erläuterungen:
          </p>
          <ul>
            <li>
              Konto-Nr.: Die Konto-Nr. wird zur Überweisung deiner Spesen benützt. In der Vergangenheit ist es einige Male passiert, dass
              Spesen verspätet ausbezahlt werden mussten, da uns Zivis die Kontonummer nicht rechtzeitig mitgeteilt hatten.
            </li>
            <li>
              Berufserfahrung: Wir profitieren gerne von deiner Erfahrung. Wenn wir genau wissen, wann wer mit welchen Erfahrungen einen
              Einsatz tätigt, können wir z.T. Projekte speziell planen.
            </li>
            <li>Führerausweis: Wir brauchen immer wieder Zivis welche bei Bedarf das Steuer übernehmen.</li>
            <li>GA/Halbtax: Informationen über allfällig vorhandene GAs/Halbtax brauchen wir für die Spesenabrechnung</li>
            <li>
              Photo: Optional, hilft uns Namen und Gesichter zu assozieren. Damit werden wir deinen Namen schon beim ersten mal kennen.
              Beachte : JPEG/GIF/BMP, Max 512kb
            </li>
          </ul>
          <p>Wichtig: Vergiss nicht zu speichern (Daten speichern) bevor du die Seite verlässt oder eine Einsatzplanung erfasst.</p>
          <p>
            Am Ende der Seite findest du eine Liste deiner Einsatzplanungen. Ist diese leer, so hast du noch keine Einsatzplanung erfasst.
            Siehe nächstes Kapitel. Klicke auf den Link drucken so wird ein PDF der Einsatzplanung generiert und in einem neuen Fenster
            angezeigt. Dieses kannst du dann drucken und an den Einsatzbetrieb schicken.
          </p>
        </Card>
        <Card>
          <h2>Einsatzverlängerung</h2>
          <p>
            Nach Absprache mit der Einsatzleitung kannst du auch einen Einsatz verlängern. Erfasse dazu eine neue Einsatzplanung, welche als
            Startdatum den Tag nach Einsatzende der vorhergehenden Einsatzplanung hat. Drucke diese Einsatzplanung und lasse sie von der
            Einsatzleitung unterschreiben.
          </p>
        </Card>
      </div>
    </Header>
  );
}
