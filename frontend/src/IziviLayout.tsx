import * as React from 'react';
import { Component } from 'react';
import Navbar from 'reactstrap/lib/Navbar';
import NavbarBrand from 'reactstrap/lib/NavbarBrand';

const Navigation = () => (
  <Navbar color={'light'}>
    <NavbarBrand href={'/'}>iZivi</NavbarBrand>
  </Navbar>
);

export class IziviLayout extends Component {
  render = () => (
    <div>
      <Navigation />
      {this.props.children}
    </div>
  );
}
