import * as React from 'react';
import { Component, ReactNode } from 'react';
import { Theme } from './theme';
import injectSheet, { WithSheet } from 'react-jss';
import createStyles from '../utilities/createStyles';
import classNames from 'classnames';

import bg from '../assets/bg.jpg';

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
  });

interface Props extends WithSheet<typeof styles> {
  children: ReactNode;
  className?: string;
  showBackgroundImage?: boolean;
}

class IziviContent extends Component<Props> {
  render = () => {
    const { classes, children, showBackgroundImage } = this.props;
    return (
      <div className={classNames(this.props.className, classes.container, { [classes.background]: showBackgroundImage })}>{children}</div>
    );
  };
}

export default injectSheet(styles)(IziviContent);
