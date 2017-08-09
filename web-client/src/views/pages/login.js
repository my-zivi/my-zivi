import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import { connect } from 'inferno-mobx';

import Card from '../tags/card';

import axios from 'axios';
import ApiService from '../../utils/api';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';

export default class Login extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: '',
      password: '',
      loading: false,
      error: null,
    };
  }

  login() {
    this.setState({ loading: true, error: null });
    axios
      .post(ApiService.BASE_URL + 'auth/login', {
        email: this.state.email,
        password: this.state.password,
      })
      .then(response => {
        localStorage.setItem('jwtToken', response.data.data.token);
        this.context.router.push('/');
      })
      .catch(error => {
        var errorBox = [];
        errorBox.push(
          <div class="alert alert-danger">
            <strong>Login fehlgeschlagen</strong>
            <br />E-Mail oder Passwort falsch!
          </div>
        );
        this.setState({ errorBox: errorBox, loading: false });
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
      <Header>
        <div className="page page__login">
          <Card>
            <form class="form-signin" action="javascript:;" onsubmit={() => this.login()}>
              <h2 class="form-signin-heading">Anmelden</h2>
              {this.state.errorBox}
              <p>
                <label for="inputEmail" class="sr-only">
                  Email
                </label>
                <input
                  type="email"
                  name="email"
                  class="form-control"
                  placeholder="Email"
                  value={this.state.email}
                  onChange={this.handleChange.bind(this)}
                  required
                  autofocus
                />
                <label for="inputPassword" class="sr-only">
                  Passwort
                </label>
                <input
                  type="password"
                  name="password"
                  class="form-control"
                  placeholder="Passwort"
                  value={this.state.password}
                  onChange={this.handleChange.bind(this)}
                  required
                />
              </p>
              <p>
                <button class="btn btn-lg btn-primary btn-block" type="submit">
                  Anmelden
                </button>
              </p>
            </form>
            <p>
              <a href="/forgotPassword">Passwort vergessen?</a>
            </p>
          </Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
