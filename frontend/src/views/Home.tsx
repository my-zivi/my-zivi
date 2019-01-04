import Card from 'reactstrap/lib/Card';
import * as React from 'react';
import CardBody from 'reactstrap/lib/CardBody';
import CardSubtitle from 'reactstrap/lib/CardSubtitle';
import CardText from 'reactstrap/lib/CardText';
import injectSheet, { WithSheet } from 'react-jss';
import { Theme } from '../layout/theme';

import bg from '../assets/bg.jpg';

const styles = (theme: Theme) => ({
  page: {
    backgroundImage: `url(${bg})`,
    backgroundSize: 'cover',
    minHeight: '94vh',
    '& p': {
      textAlign: 'justify' as 'justify',
    },
    '& ul': {
      paddingLeft: 2 * theme.layout.baseSpacing,
      paddingRight: 2 * theme.layout.baseSpacing,
      textAlign: 'justify' as 'justify',
    },
  },
  card: {
    background: 'rgba(255, 255, 255, 0.9)',
    height: 'auto',
    '& span': {
      fontSize: '3rem',
      fontWeight: 'bold' as 'bold',
    },
  },
});

interface Props extends WithSheet<typeof styles> {}

class HomeInner extends React.Component<Props> {
  render() {
    const { classes } = this.props;
    return (
      <div className={classes.page}>
        <Card className={classes.card}>
          <CardBody>
            <CardSubtitle>
              <span>iZivi</span> ist ein Tool der SWO zur Erfassung und Planung von Zivildienst-Einsätzen
            </CardSubtitle>
            <CardText>
              Seit 1996 können Militärpflichtige, die den Militärdienst aus Gewissensgründen ablehnen, einen zivilen Ersatzdienst leisten.
              Die SWO hat den Zivildienst mitgestaltet und bietet Zivildienstleistenden eine Vielzahl von sinnvollen Einsatzmöglichkeiten
              zugunsten einer nachhaltigen Entwicklung.
            </CardText>
          </CardBody>
        </Card>
      </div>
    );
  }
}

export const Home = injectSheet(styles)(HomeInner);
