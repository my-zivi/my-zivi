import Inferno from 'inferno';
import Component from 'inferno-component';
import { connect } from 'inferno-mobx';

export default class Logout extends Component {
  constructor(props, { router }) {
    super(props);
    localStorage.removeItem('jwtToken');
    router.push('/');
  }
}
