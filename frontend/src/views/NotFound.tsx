import * as React from 'react';
import { Link } from 'react-router-dom';
import IziviContent from '../layout/IziviContent';

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
