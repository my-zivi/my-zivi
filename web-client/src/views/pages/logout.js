import Inferno from 'inferno';
import Component from 'inferno-component';
import { connect } from 'inferno-mobx';

@connect(['accountStore'])
export default class Logout extends Component {
  constructor(props, { router }) {
    super(props);

    this.props.accountStore.isLoggedIn = false;
    this.props.accountStore.isAdmin = false;
    localStorage.removeItem('jwtToken');
    router.push('/');
  }
}
