import React from 'react';
import Auth from '../../utils/auth';
import Card from '../tags/card';
import Header from '../tags/header';

export default function(props) {
  return (
    <Header>
      <div className="page page__home background-image">
        <br />
        <Card>
          <h1>
            iZivi <span> ist ein Tool der SWO zur Erfassung und Planung von Zivildienst-Einsätzen</span>
          </h1>
          <p>
            Seit 1996 können Militärpflichtige, die den Militärdienst aus Gewissensgründen ablehnen, einen zivilen Ersatzdienst leisten. Die
            SWO hat den Zivildienst mitgestaltet und bietet Zivildienstleistenden eine Vielzahl von sinnvollen Einsatzmöglichkeiten
            zugunsten einer nachhaltigen Entwicklung.
          </p>

          {!Auth.isLoggedIn() && (
            <React.Fragment>
              <p>
                Bist du das erste Mal bei uns und möchtest einen Einsatz planen? Dann kannst du dich über folgenden Link{' '}
                <a href="/register" target="_self">
                  Registrieren
                </a>
                .
              </p>
              <p>
                Falls du uns bereits bekannt bist, kannst du dich hier{' '}
                <a href="/login" target="_self" rel="noopener noreferrer">
                  Anmelden
                </a>
                .
              </p>
            </React.Fragment>
          )}
        </Card>
      </div>
    </Header>
  );
}
