import * as React from 'react';
import { Component, ReactNode } from 'react';
import { Theme } from './theme';
import injectSheet, { WithSheet } from 'react-jss';
import createStyles from '../utilities/createStyles';
import classNames from 'classnames';

import bg from '../assets/bg.jpg';
import Card from 'reactstrap/lib/Card';
import CardBody from 'reactstrap/lib/CardBody';

const styles = (theme: Theme) =>
  createStyles({
    container: {
      padding: `${theme.layout.baseSpacing}px ${2 * theme.layout.baseSpacing}px`,
    },
    background: {
      backgroundImage: `url(${bg})`,
      backgroundSize: 'cover',
      minHeight: '94vh',
    },
    card: {
      background: 'rgba(255, 255, 255, 0.9)',
      height: 'auto',
    },
  });

interface Props extends WithSheet<typeof styles> {
  children: ReactNode;
  className?: string;
  showBackgroundImage?: boolean;
  card?: boolean;
  title?: string;
}

class IziviContent extends Component<Props> {
  render = () => {
    const { classes, children, showBackgroundImage, card, title } = this.props;
    return (
      <div className={classNames(this.props.className, classes.container, { [classes.background]: showBackgroundImage })}>
        {card ? (
          <Card className={classes.card}>
            <CardBody>
              {title && <h1>{title}</h1>}
              <br />
              {children}
            </CardBody>
          </Card>
        ) : (
          <div>
            {title && <h1>{title}</h1>}
            {children}
          </div>
        )}
      </div>
    );
  };
}

export default injectSheet(styles)(IziviContent);
