import React, { Component } from 'react';
import Auth from '../../utils/auth';
import { Redirect } from 'react-router-dom';

export default class Logout extends Component {
  constructor(props) {
    super(props);
    Auth.removeToken();
  }

  render() {
    return <Redirect to={'/'} />;
  }
}
