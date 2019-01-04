import injectSheet from 'react-jss';
import * as React from 'react';
import createStyles from '../utilities/createStyles';

export const theme = {
  colors: {
    blue: '#90CAF9',
    primary: '#90CAF9',
    black: '#212121',
    offwhite: '#F5F5F5',
    white: '#FFF',
  },
  layout: {
    baseSpacing: 16,
  },
};

export type Theme = typeof theme;

const globalStyles = (theme: Theme) =>
  createStyles({
    '@global': {
      body: {
        margin: 0,
        padding: 0,
        color: theme.colors.black,
        background: theme.colors.offwhite,
        fontFamily: "'Helvetica Neue', Arial, Helvetica, sans-serif",
        width: '100vw',
        minHeight: '100vh',
        overflowX: 'hidden',
        fontWeight: 400,
      },
      a: {
        color: theme.colors.primary,
      },
      'li, p': {
        marginBottom: theme.layout.baseSpacing / 2,
      },
    },
  });

class CssBaselineInner extends React.Component {
  render() {
    return this.props.children || null;
  }
}
export const CssBaseline = injectSheet(globalStyles)(CssBaselineInner);
