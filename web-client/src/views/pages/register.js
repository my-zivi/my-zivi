import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';

import { connect } from 'inferno-mobx';

import Card from '../tags/card';

@connect(['accountStore'])
export default class Register extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: '',
      password: '',
    };
  }

  register() {
    let self = this;
    axios
      .post(ApiService.BASE_URL + '/auth/register', {
        email: this.state.email,
        password: this.state.password,
      })
      .then(response => {
        this.props.accountStore.isLoggedIn = true;
        this.props.accountStore.isAdmin = true;
        localStorage.setItem('jwtToken', response.data.data.token);
        self.context.router.push('/');
      })
      .catch(error => {
        let errorMsg = '';
        errorMsg += 'Request failed!\nPlease check the following field(s):\n\n';
        for (let item in error.response.data) {
          errorMsg += item + ': ' + error.response.data[item] + '\n';
        }
        alert(errorMsg);
      });
  }

  handleChange(e) {
    switch (e.target.name) {
      case 'email':
        this.setState({ email: e.target.value });
        break;
      case 'password':
        this.setState({ password: e.target.value });
        break;
      default:
        console.log('Element not found for setting.');
    }
  }

  render() {
    return (
      <div className="page page__register">
        <Card>
          <h1>Registrieren</h1>
          Email:
          <br />
          <input type="text" name="email" value={this.state.email} onChange={this.handleChange.bind(this)} />
          <br />
          Password:
          <br />
          <input type="password" name="password" value={this.state.password} onChange={this.handleChange.bind(this)} />
          <br />
          <button onClick={() => this.register()}>Registrieren</button>
        </Card>
      </div>
    );
  }
}
