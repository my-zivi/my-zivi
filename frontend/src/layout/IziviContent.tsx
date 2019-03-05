import * as React from 'react';
import { Component, ReactNode } from 'react';
import { Theme } from './theme';
import injectSheet, { WithSheet } from 'react-jss';
import createStyles from '../utilities/createStyles';
import classNames from 'classnames';

import bg from '../assets/bg.jpg';
import Card from 'reactstrap/lib/Card';
import CardBody from 'reactstrap/lib/CardBody';
import { LoadingInformation } from './LoadingInformation';

const styles = (theme: Theme) =>
  createStyles({
    container: {
      '@media (min-width: 1024px)': {
        padding: `${theme.layout.baseSpacing}px ${2 * theme.layout.baseSpacing}px`,
      },
      composes: 'mo-container',
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
  loading?: boolean;
}

class IziviContent extends Component<Props> {
  constructor(props: Props) {
    super(props);
    if (this.props.title) {
      document.title = `iZivi - ${this.props.title}`;
    } else {
      document.title = `iZivi`;
    }
  }

  render = () => {
    const { classes, children, loading, showBackgroundImage, card, title } = this.props;
    const content = loading ? <LoadingInformation /> : children;

    return (
      <div className={classNames(this.props.className, classes.container, { [classes.background]: showBackgroundImage })}>
        {card ? (
          <Card className={classes.card}>
            <CardBody>
              {title && <h1>{title}</h1>}
              <br />
              {content}
            </CardBody>
          </Card>
        ) : (
          <div>
            {title && <h1>{title}</h1>}
            {content}
          </div>
        )}
      </div>
    );
  };
}

export default injectSheet(styles)(IziviContent);
