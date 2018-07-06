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
        <div className="page page__register">
          <Card>
            <h1>Registrieren</h1>
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
                    ZDP:
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="number"
                      className="form-control"
                      name="zdp"
                      id="zdp"
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
                      placeholder=""
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
                      placeholder=""
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
                  <label className="control-label col-sm-3" htmlFor="newsletter">
                    Newsletter:
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="checkbox"
                      id="newsletter"
                      name="newsletter"
                      checked={this.state.formData.newsletter}
                      onChange={this.handleChange.bind(this)}
                      className="form-control"
                    />
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
