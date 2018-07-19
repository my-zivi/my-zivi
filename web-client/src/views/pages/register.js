import { Component } from 'inferno';
import Card from '../tags/card';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import { api } from '../../utils/api';
import Auth from '../../utils/auth';

export default class Register extends Component {
  constructor(props) {
    super(props);

    this.state = {
      formData: {
        zdp: '',
        firstname: '',
        lastname: '',
        email: '',
        password: '',
        password_confirm: '',
        community_pw: '',
        newsletter: false,
      },
    };
  }

  register() {
    this.setState({ loading: true, error: null });
    api()
      .post('auth/register', this.state.formData)
      .then(response => {
        Auth.setToken(response.data.data.token);
        this.context.router.history.push('/');
      })
      .catch(error => {
        var errorMsg = [];
        if (error.response != null && error.response.data != null) {
          for (let item in error.response.data) {
            errorMsg.push(
              <p>
                {item}: {error.response.data[item]}
              </p>
            );
          }
        }
        var errorBox = [];
        errorBox.push(
          <div class="alert alert-danger">
            <strong>Registration fehlgeschlagen</strong>
            <br />
            {errorMsg}
          </div>
        );
        this.setState({ errorBox: errorBox, loading: false });
      });
  }

  handleChange(e) {
    this.setState({
      formData: {
        ...this.state.formData,
        [e.target.name]: e.target.type === 'checkbox' ? e.target.checked : e.target.value,
      },
    });
  }

  render() {
    return (
      <Header>
        <div className="page page__register">
          <Card>
            <h1>Registrieren</h1>
            <ul>
              <li>
                Als zukünftiger Zivi musst du dich zuerst erkundigen, ob zum gewünschten Zeitpunkt ein Einsatz möglich ist. Kontaktiere
                hierfür bitte direkt{' '}
                <a href="//stiftungswo.ch/about/meet-the-team#jumptomarc" target="_blank">
                  {' '}
                  Marc Pfeuti
                </a>{' '}
                unter <a href="mailto:mp@stiftungswo.ch">mp@stiftungswo.ch</a>.
              </li>
              <li>Ist ein Einsatz grundsätzlich möglich, wirst du im allgemeinen einen halben Schnuppertag absolvieren müssen.</li>
              <li>
                Hat dir der Schnuppertag gefallen und die Einsatzleistung ist mit deiner Motivation / Leistung zufrieden, so wird dir die
                Einsatzleitung ein Community Passwort bekannt gegeben, mit welchem du dir auf dieser Seite einen Account eröffnen und die
                Einsatzplanung erstellen kannst.
              </li>
              <li>Danach gibst du deine persönlichen Daten und die Einsatzplanung ein und druckst diese aus.</li>
              <li>Die Einsatzplanung brauchst du nun nur noch zu unterschreiben und an den Einsatzbetrieb zurückzuschicken.</li>
              <li>Der Einsatzbetrieb unterschreibt dann die Einsatzplanung und leitet sie an die Regionalstelle weiter.</li>
              <li>Das Aufgebot erhältst du dann automatisch von der Regionalstelle.</li>
            </ul>
            <div class="container">
              {this.state.errorBox}
              <form
                id="registerForm"
                onSubmit={e => {
                  e.preventDefault();
                  this.register();
                }}
                class="form-horizontal"
                data-toggle="validator"
              >
                <hr />
                <h3>Persönliche Informationen</h3>
                <br />

                <div class="form-group">
                  <label class="control-label col-sm-3" for="zdp">
                    ZDP:
                  </label>
                  <div class="col-sm-9">
                    <input
                      type="number"
                      class="form-control"
                      name="zdp"
                      id="zdp"
                      value={this.state.formData.zdp}
                      onInput={this.handleChange.bind(this)}
                      min="10000"
                      max="1000000"
                      required
                    />
                  </div>
                </div>
                <div class="form-group">
                  <label class="control-label col-sm-3" for="firstname">
                    Vorname:
                  </label>
                  <div class="col-sm-9">
                    <input
                      type="text"
                      class="form-control"
                      name="firstname"
                      id="firstname"
                      value={this.state.formData.firstname}
                      onInput={this.handleChange.bind(this)}
                      required
                    />
                  </div>
                </div>
                <div class="form-group">
                  <label class="control-label col-sm-3" for="lastname">
                    Nachname:
                  </label>
                  <div class="col-sm-9">
                    <input
                      type="text"
                      class="form-control"
                      name="lastname"
                      id="lastname"
                      value={this.state.formData.lastname}
                      onInput={this.handleChange.bind(this)}
                      required
                    />
                  </div>
                </div>
                <div class="form-group">
                  <label class="control-label col-sm-3" for="email">
                    E-Mail:
                  </label>
                  <div class="col-sm-9">
                    <input
                      type="email"
                      class="form-control"
                      name="email"
                      id="email"
                      value={this.state.formData.email}
                      onInput={this.handleChange.bind(this)}
                      required
                      autoComplete="username email"
                    />
                  </div>
                </div>

                <div class="form-group has-feedback">
                  <label class="control-label col-sm-3" for="password">
                    Passwort:
                  </label>
                  <div class="col-sm-9">
                    <input
                      type="password"
                      id="password"
                      name="password"
                      value={this.state.formData.password}
                      onInput={this.handleChange.bind(this)}
                      className="form-control"
                      data-minlength="7"
                      placeholder=""
                      required
                      autoComplete="new-password"
                    />
                  </div>
                  <div class="col-sm-3" />
                  <div class="help-block col-sm-9">Mindestens 7 Zeichen</div>
                </div>

                <div class="form-group has-feedback">
                  <label class="control-label col-sm-3" for="password_confirm">
                    Passwort Bestätigung:
                  </label>
                  <div class="col-sm-9">
                    <input
                      type="password"
                      id="password_confirm"
                      name="password_confirm"
                      value={this.state.formData.password_confirm}
                      onInput={this.handleChange.bind(this)}
                      className="form-control"
                      data-match="#password"
                      data-match-error="Die beiden Eingaben stimmen nicht überein"
                      placeholder=""
                      required
                      autoComplete="new-password"
                    />
                  </div>
                  <div class="col-sm-3" />
                  <div class="help-block with-errors col-sm-9" />
                </div>

                <div class="form-group has-feedback">
                  <label class="control-label col-sm-3" for="community_pw">
                    Community Passwort:
                  </label>
                  <div class="col-sm-9">
                    <input
                      type="password"
                      id="community_pw"
                      name="community_pw"
                      value={this.state.formData.community_pw}
                      onInput={this.handleChange.bind(this)}
                      className="form-control"
                      required
                    />
                  </div>
                  <div class="col-sm-3" />
                  <div class="help-block with-errors col-sm-9" />
                </div>

                <div class="form-group has-feedback">
                  <label class="control-label col-sm-3" for="newsletter">
                    Newsletter:
                  </label>
                  <div class="col-sm-9">
                    <input
                      type="checkbox"
                      id="newsletter"
                      name="newsletter"
                      value={this.state.formData.newsletter}
                      onInput={this.handleChange.bind(this)}
                      className="form-control"
                    />
                  </div>
                  <div class="col-sm-3" />
                  <div class="help-block with-errors col-sm-9" />
                </div>
                <hr />

                <button type="submit" class="btn btn-primary">
                  Registrieren
                </button>
              </form>
            </div>
          </Card>

          <LoadingView loading={this.state.loading} error={this.state.error} />
        </div>
      </Header>
    );
  }

  //initialize validation after render
  componentDidUpdate() {
    window.$('#registerForm').validator();
  }
}
