import Card from '../tags/card';
import Header from '../tags/header';

export default function(props) {
  return (
    <Header>
      <div className="page page__home background-image">
        <br />
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
            <a href="//izivi.stiftungswo.ch/login" target="_self" rel="noopener noreferrer">
              Anmelden
            </a>.
          </p>
        </Card>
      </div>
    </Header>
  );
}
