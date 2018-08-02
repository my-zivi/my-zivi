import React, { Component } from 'react';
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
        this.props.history.push('/');
      })
      .catch(error => {
        var errorMsg = [];
        if (error.response != null && error.response.data != null) {
          for (let item in error.response.data) {
            errorMsg.push(
              <p key={item}>
                {item}: {error.response.data[item]}
              </p>
            );
          }
        }
        var errorBox = (
          <div className="alert alert-danger">
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
        <div className="page page__register background-image">
          <br />
          <Card>
            <h2>Registrieren</h2>
            <p>
              Als zukünftiger Zivi musst du dich zuerst erkundigen, ob zum gewünschten Zeitpunkt ein Einsatz möglich ist. Kontaktiere
              hierfür bitte direkt{' '}
              <a href="//stiftungswo.ch/about/meet-the-team#jumptomarc" target="_blank">
                {' '}
                Marc Pfeuti{' '}
              </a>
              unter{' '}
              <a
                href="mailto:mp@stiftungswo.ch?subject=Einsatzplanung Zivildienst&body=Guten Tag Herr Pfeuti!
              %0D%0A%0D%0AIch schreibe Ihnen betreffend meiner Einsatzplanung als FELDZIVI / BÜROZIVI (EINS AUSWÄHLEN) vom DD.MM.YYYY bis DD.MM.YYYY, wäre dieser Zeitraum möglich?
              %0D%0A%0D%0A
              %0D%0A%0D%0ABesten Dank und freundliche Grüsse"
              >
                {' '}
                mp@stiftungswo.ch{' '}
              </a>
              .
            </p>
            <ul type="circle">
              <li>
                Ist ein Einsatz grundsätzlich möglich, wirst du im allgemeinen einen halben Schnuppertag absolvieren müssen. Hat dir der
                Schnuppertag gefallen und die Einsatzleitung ist mit deiner Motivation & Leistung zufrieden, so wird dir ein Community
                Passwort bekannt gegeben, mit welchem du dir auf dieser Seite deinen Account eröffnen und die Einsatzplanung erstellen
                kannst.
              </li>
              <li>
                Nach Eingabe deiner persönlichen Daten kannst du die Einsatzplanung ausdrucken, unterschreiben und an den Einsatzbetrieb
                zurückzuschicken. Nach erfolgreicher Prüfung werden wir diese direkt an dein zuständiges Regionalzentrum weiterleiten. Das
                Aufgebot erhältst du dann automatisch von deinem zuständigen Regionalzentrum.
              </li>
            </ul>
            <div className="container">
              {this.state.errorBox}
              <form
                id="registerForm"
                onSubmit={e => {
                  e.preventDefault();
                  this.register();
                }}
                className="form-horizontal"
                data-toggle="validator"
              >
                <hr />
                <h3>Persönliche Informationen</h3>
                <br />

                <div className="form-group">
                  <label className="control-label col-sm-3" htmlFor="zdp">
                    Zivildienstnummer (ZDP):
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="number"
                      className="form-control"
                      name="zdp"
                      id="zdp"
                      placeholder="Dies ist deine Zivildienst-Nummer, welche du auf deinem Aufgebot wiederfindest"
                      value={this.state.formData.zdp}
                      onChange={this.handleChange.bind(this)}
                      min="10000"
                      max="1000000"
                      required
                    />
                  </div>
                </div>
                <div className="form-group">
                  <label className="control-label col-sm-3" htmlFor="firstname">
                    Vorname:
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="text"
                      className="form-control"
                      name="firstname"
                      id="firstname"
                      placeholder="Dein Vorname"
                      value={this.state.formData.firstname}
                      onChange={this.handleChange.bind(this)}
                      required
                    />
                  </div>
                </div>
                <div className="form-group">
                  <label className="control-label col-sm-3" htmlFor="lastname">
                    Nachname:
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="text"
                      className="form-control"
                      name="lastname"
                      id="lastname"
                      placeholder="Dein Nachname"
                      value={this.state.formData.lastname}
                      onChange={this.handleChange.bind(this)}
                      required
                    />
                  </div>
                </div>
                <div className="form-group">
                  <label className="control-label col-sm-3" htmlFor="email">
                    E-Mail:
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="email"
                      className="form-control"
                      name="email"
                      id="email"
                      placeholder="Wird für das zukünftige Login sowie das Versenden von Systemnachrichten benötigt"
                      value={this.state.formData.email}
                      onChange={this.handleChange.bind(this)}
                      required
                      autoComplete="username email"
                    />
                  </div>
                </div>

                <div className="form-group has-feedback">
                  <label className="control-label col-sm-3" htmlFor="password">
                    Passwort:
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="password"
                      id="password"
                      name="password"
                      value={this.state.formData.password}
                      onChange={this.handleChange.bind(this)}
                      className="form-control"
                      data-minlength="7"
                      placeholder="Ein frei wählbares Passwort mit mindestens 7 Zeichen"
                      required
                      autoComplete="new-password"
                    />
                  </div>
                  <div className="col-sm-3" />
                  <div className="help-block col-sm-9">Mindestens 7 Zeichen</div>
                </div>

                <div className="form-group has-feedback">
                  <label className="control-label col-sm-3" htmlFor="password_confirm">
                    Passwort Bestätigung:
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="password"
                      id="password_confirm"
                      name="password_confirm"
                      value={this.state.formData.password_confirm}
                      onChange={this.handleChange.bind(this)}
                      className="form-control"
                      data-match="#password"
                      data-match-error="Die beiden Eingaben stimmen nicht überein"
                      placeholder="Wiederhole dein gewähltes Passwort"
                      required
                      autoComplete="new-password"
                    />
                  </div>
                  <div className="col-sm-3" />
                  <div className="help-block with-errors col-sm-9" />
                </div>

                <div className="form-group has-feedback">
                  <label className="control-label col-sm-3" htmlFor="community_pw">
                    Community Passwort:
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="password"
                      id="community_pw"
                      name="community_pw"
                      placeholder="Dieses erhälst du von der Einsatzleitung welche dich berechtigt einen Account zu eröffnen"
                      value={this.state.formData.community_pw}
                      onChange={this.handleChange.bind(this)}
                      className="form-control"
                      required
                    />
                  </div>
                  <div className="col-sm-3" />
                  <div className="help-block with-errors col-sm-9" />
                </div>

                <div className="form-group has-feedback">
                  <div className="col-sm-3" />
                  <div className="col-sm-9">
                    <div className="form-check">
                      <input
                        type="checkbox"
                        id="newsletter"
                        name="newsletter"
                        value={this.state.formData.newsletter}
                        onInput={this.handleChange.bind(this)}
                        className="form-check-input"
                      />
                      <label className="form-check-label" htmlFor="newsletter">
                        &nbsp;&nbsp;Ja, ich möchte den Newsletter erhalten!
                      </label>
                    </div>
                  </div>
                  <div className="col-sm-3" />
                  <div className="help-block with-errors col-sm-9" />
                </div>
                <hr />

                <button type="submit" className="btn btn-primary">
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
