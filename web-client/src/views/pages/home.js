import Card from '../tags/card';
import Header from '../tags/header';

export default function(props) {
  return (
    <Header>
      <div className="page page__home">
        <Card>
          <h1>iZivi</h1>
          <br />
          <p>iZivi ist ein Tool zur Erfassung und Planung von Zivi-Einsätzen.</p>
          <p>
            Wähle einen der Menupunkte (oben) aus, um dich einzuloggen. Bist du ein Zivi, der seinen Einsatz bei uns eintragen will, so
            musst du zuerst ein Benutzerkonto erstellen. Mache dies, indem du auf den Menüpunkt Account erstellen klickst.
          </p>
        </Card>

        <Card>
          <h2>Einführung</h2>
          <p>iZivi soll ...</p>
          <ul>
            <li>eine einfache Planung und Übersicht der Zivildiensteinsätze ermöglichen.</li>
            <li>interne Abläufe zur Zivi-Administration vereinfachen.</li>
            <li>zukünftigen Zivis das Ausfüllen der Einsatzplanung vereinfachen.</li>
            <li>für die Regionalstellen leserliche Einsatzplanungen erstellen.</li>
          </ul>
        </Card>

        <Card>
          <h2>Ablauf der Planung eines Einsatzes</h2>
          <ul>
            <li>
              Als zukünftiger Zivi musst du dich zuerst erkundigen, ob zum gewünschten Zeitpunkt ein Einsatz möglich ist. Erkundige dich
              bitte direkt bei{' '}
              <a href="//stiftungswo.ch/about/meet-the-team" target="_blank">
                Marc Pfeuti
              </a>.
            </li>
            <li>Ist ein Einsatz grundsätzlich möglich, wirst du im allgemeinen einen halben Schnuppertag absolvieren müssen.</li>
            <li>
              Hat dir der Schnuppertag gefallen und die Einsatzleistung ist mit deiner Motivation / Leistung zufrieden, so wird dir die
              Einsatzleitung ein Community Passwort bekannt gegeben, mit welchem du dir auf dieser Seite einen Account eröffnen und die
              Einsatzplanung erstellen kannst.
            </li>
            <li>Danach gibst du deine persönlichen Daten und die Einsatzplanung ein und druckst diese aus.</li>
            <li>Die Einsatzplanung brauchst du nun nur noch zu unterschreiben und an den Einsatzbetrieb zurückzuschicken.</li>
            <li>Der Einsatzbetrieb unterschreibt dann die Einsatzplanung und leitet sie an die Regionalstelle weiter.</li>
            <li>Das Aufgebot erhältst du dann automatisch von der Regionalstelle.</li>
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
          <h2>Einsatzplanung erfassen</h2>
          <p>
            Um eine Einsatzplanung zu erfassen musst du nur das Pflichtenheft auswählen und Start- und Enddatum eingeben. Beachte:
            Zivi-Einsätze im Naturschutz müssen an einem Montag beginnen und an einem Freitag enden, ausser es handelt sich um deinen
            letzten Zivi Einsatz und du leistest nur noch die verbleibenden Resttage.
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
