import * as React from 'react';
import IziviContent from '../layout/IziviContent';
import { Link } from 'react-router-dom';

export class NotFound extends React.Component {
  render() {
    return (
      <IziviContent card showBackgroundImage title={'Seite nicht gefunden'}>
        <p>
          Die angeforderte Seite konnte nicht gefunden werden. <Link to={'/'}>Hier</Link> geht es zurück zur Startseite.
        </p>
      </IziviContent>
    );
  }
}
