import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import axios from 'axios';
import ApiService from '../../utils/api';
import { connect } from 'inferno-mobx';
import Card from '../tags/card';

@connect(['accountStore'])
export default class Register extends Component {
  constructor(props) {
    super(props);

    this.state = {
      formData: {},
    };
  }

  register() {
    let self = this;
    axios
      .post(ApiService.BASE_URL + 'auth/register', this.state.formData)
      .then(response => {
        this.props.accountStore.isLoggedIn = true;
        this.props.accountStore.isAdmin = true;
        localStorage.setItem('jwtToken', response.data.data.token);
        self.context.router.push('/');
      })
      .catch(error => {
        var errorMsg = [];
        for (let item in error.response.data) {
          errorMsg.push(
            <p>
              {item}: {error.response.data[item]}
            </p>
          );
        }
        var errorBox = [];
        errorBox.push(
          <div class="alert alert-danger">
            <strong>Registration fehlgeschlagen</strong>
            <br />
            {errorMsg}
          </div>
        );
        this.setState({ errorBox: errorBox });
      });
  }

  handleChange(e) {
    this.state.formData[e.target.name] = e.target.value;
    this.setState({ formData: this.state.formData });
  }

  render() {
    return (
      <div className="page page__register">
        <Card>
          <h1>Registrieren</h1>
          {this.state.errorBox}
          <form action="javascript:;" onSubmit={() => this.register()}>
            <div class="form-group">
              <label for="zdp">ZDP:</label>
              <input
                type="number"
                class="form-control"
                name="zdp"
                id="zdp"
                value={this.state.formData.zdp}
                onChange={this.handleChange.bind(this)}
                min="10000"
                max="100000"
                required
              />
            </div>
            <div class="form-group">
              <label for="firstname">Vorname:</label>
              <input
                type="text"
                class="form-control"
                name="firstname"
                id="firstname"
                value={this.state.formData.firstname}
                onChange={this.handleChange.bind(this)}
                required
              />
            </div>
            <div class="form-group">
              <label for="lastname">Nachname:</label>
              <input
                type="text"
                class="form-control"
                name="lastname"
                id="lastname"
                value={this.state.formData.lastname}
                onChange={this.handleChange.bind(this)}
                required
              />
            </div>
            <div class="form-group">
              <label for="email">E-Mail:</label>
              <input
                type="email"
                class="form-control"
                name="email"
                id="email"
                value={this.state.formData.email}
                onChange={this.handleChange.bind(this)}
                required
              />
            </div>
            <div class="form-group">
              <label for="password">Passwort:</label>
              <input
                type="password"
                class="form-control"
                name="password"
                id="password"
                value={this.state.formData.password}
                onChange={this.handleChange.bind(this)}
                required
              />
            </div>
            <div class="form-group">
              <label for="password_confirm">Passwort Bestätigung:</label>
              <input
                type="password"
                class="form-control"
                name="password_confirm"
                id="password_confirm"
                value={this.state.formData.passwordConfirm}
                onChange={this.handleChange.bind(this)}
                required
              />
            </div>

            <button type="submit" class="btn btn-primary">
              Registrieren
            </button>
          </form>
        </Card>
      </div>
    );
  }
}
