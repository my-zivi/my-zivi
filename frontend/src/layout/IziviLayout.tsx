import * as React from 'react';
import { Component } from 'react';
import { CssBaseline } from './theme';
import { Navigation } from './Navigation';

export class IziviLayout extends Component {
  render = () => (
    <div>
      <CssBaseline />
      <Navigation />
      {this.props.children}
    </div>
  );
}
