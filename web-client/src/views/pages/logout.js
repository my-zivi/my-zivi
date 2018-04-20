import { Component } from 'inferno';

export default class Logout extends Component {
  constructor(props) {
    super(props);
    localStorage.removeItem('jwtToken');
    props.history.push('/');
  }
}
