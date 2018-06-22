import { Component } from 'inferno';
import Auth from '../../utils/auth';

export default class Logout extends Component {
  constructor(props) {
    super(props);
    Auth.removeToken();
    props.history.push('/');
  }
}
