import * as React from 'react';
import CardSubtitle from 'reactstrap/lib/CardSubtitle';
import CardText from 'reactstrap/lib/CardText';
import injectSheet, { WithSheet } from 'react-jss';
import { Theme } from '../layout/theme';
import createStyles from '../utilities/createStyles';
import IziviContent from '../layout/IziviContent';
import { inject, observer } from 'mobx-react';
import { ApiStore } from '../stores/apiStore';
import { Link } from 'react-router-dom';

const styles = (theme: Theme) =>
  createStyles({
    page: {
      '& p': {
        textAlign: 'justify',
      },
      '& ul': {
        paddingLeft: 2 * theme.layout.baseSpacing,
        paddingRight: 2 * theme.layout.baseSpacing,
        textAlign: 'justify',
      },
    },
  });

interface Props extends WithSheet<typeof styles> {
  apiStore?: ApiStore;
}

@inject('apiStore')
@observer
class HomeInner extends React.Component<Props> {
  render() {
    const { classes } = this.props;
    return (
      <IziviContent className={classes.page} card showBackgroundImage>
        <CardSubtitle>
          <span>iZivi</span> ist ein Tool der SWO zur Erfassung und Planung von Zivildienst-Einsätzen
        </CardSubtitle>
        <CardText>
          Seit 1996 können Militärpflichtige, die den Militärdienst aus Gewissensgründen ablehnen, einen zivilen Ersatzdienst leisten. Die
          SWO hat den Zivildienst mitgestaltet und bietet Zivildienstleistenden eine Vielzahl von sinnvollen Einsatzmöglichkeiten zugunsten
          einer nachhaltigen Entwicklung.
        </CardText>
        {this.props.apiStore!.isLoggedIn || (
          <>
            <CardText>
              Bist du das erste Mal bei uns und möchtest einen Einsatz planen? Dann kannst du dich über folgenden Link{' '}
              <Link to={'/register'}>registrieren</Link>
            </CardText>
            <CardText>
              Falls du uns bereits bekannt bist, kannst du dich hier <Link to={'/login'}>anmelden</Link>
            </CardText>
          </>
        )}
      </IziviContent>
    );
  }
}

export const Home = injectSheet(styles)(HomeInner);
