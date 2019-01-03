import Card from 'reactstrap/lib/Card';
import * as React from 'react';
import CardBody from 'reactstrap/lib/CardBody';
import CardSubtitle from 'reactstrap/lib/CardSubtitle';
import CardText from 'reactstrap/lib/CardText';

export class Home extends React.Component {
  render() {
    return (
      <Card>
        <CardBody>
          <CardSubtitle>iZivi ist ein Tool der SWO zur Erfassung und Planung von Zivildienst-Einsätzen</CardSubtitle>
          <CardText>
            Seit 1996 können Militärpflichtige, die den Militärdienst aus Gewissensgründen ablehnen, einen zivilen Ersatzdienst leisten. Die
            SWO hat den Zivildienst mitgestaltet und bietet Zivildienstleistenden eine Vielzahl von sinnvollen Einsatzmöglichkeiten
            zugunsten einer nachhaltigen Entwicklung.
          </CardText>
        </CardBody>
      </Card>
    );
  }
}
