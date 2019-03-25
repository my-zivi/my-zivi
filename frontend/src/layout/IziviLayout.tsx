import * as React from 'react';
import { Navigation } from './Navigation';
import { CssBaseline } from './theme';

export class IziviLayout extends React.Component {
  render = () => (
    <div>
      <CssBaseline />
      <Navigation />
      {this.props.children}
    </div>
  )
}
