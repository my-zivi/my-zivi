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
      </div>
    </Header>
  );
}
