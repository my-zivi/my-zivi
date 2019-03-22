import * as React from 'react';
import injectSheet, { WithSheet } from 'react-jss';
import createStyles from '../utilities/createStyles';

const styles = () =>
  createStyles({
    hr: {
      borderTop: 'solid 2px #286090',
    },
  });

const HorizontalRowInner = (props: WithSheet<typeof styles>) => <hr className={props.classes.hr} />;

export const SolidHorizontalRow = injectSheet(styles)(HorizontalRowInner);
