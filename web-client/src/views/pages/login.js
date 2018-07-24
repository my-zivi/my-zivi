import { Component } from 'inferno';
import { Redirect } from 'inferno-router';

import Card from '../tags/card';
import Auth from '../../utils/auth';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import { api } from '../../utils/api';

export default class Login extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: '',
      password: '',
      loading: false,
      error: null,
      redirectToReferrer: false,
    };
  }

  async login() {
    this.setState({ loading: true, error: null });
    try {
      let response = await api().post('auth/login', {
        email: this.state.email,
        password: this.state.password,
      });
      Auth.setToken(response.data.data.token);

      this.setState({ redirectToReferrer: true, loading: false });
    } catch (error) {
      let errorBox = [];
      errorBox.push(
        <div class="alert alert-danger">
          <strong>Login fehlgeschlagen</strong>
          <br />E-Mail oder Passwort falsch!
        </div>
      );
      this.setState({ errorBox: errorBox, loading: false });
    }
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

  getReferrer() {
    let { state, search } = this.props.location;
    // check for referer in router state (from ProtectedRoute in index.js)
    if (state && state.referrer) {
      return state.referrer;
    }

    // check for the old 'path' query parameter
    const query = new URLSearchParams(search);

    if (query.has('path')) {
      let url = query.get('path');
      if (url.startsWith('/login')) {
        url = '/';
      }
      return url;
    }
    return '/';
  }

  render() {
    if (this.state.redirectToReferrer) {
      return <Redirect to={this.getReferrer()} />;
    }

    return (
      <Header>
        <div className="page page__login">
          <br />
          <Card>
            <form
              class="form-signin"
              onSubmit={e => {
                e.preventDefault();
                this.login();
              }}
            >
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
                  onInput={this.handleChange.bind(this)}
                  required
                  autoFocus
                  autoComplete="username email"
                />
                <br />
                <label for="inputPassword" class="sr-only">
                  Passwort
                </label>
                <input
                  type="password"
                  name="password"
                  class="form-control"
                  placeholder="Passwort"
                  value={this.state.password}
                  onInput={this.handleChange.bind(this)}
                  required
                  autoComplete="current-password"
                />
              </p>
              <p>
                <br />
                <button class="btn btn-md btn-primary" type="submit">
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
