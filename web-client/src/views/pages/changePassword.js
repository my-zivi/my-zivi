import Card from '../tags/card';
import React, { Component } from 'react';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import { api } from '../../utils/api';

export default class ChangePassword extends Component {
  constructor(props) {
    super(props);

    this.state = {
      old_password: '',
      new_password: '',
      new_password_2: '',
    };
  }

  save() {
    this.setState({ loading: true, error: null });
    let errorMsg = [];
    let errorBox = [];
    let confirmBox = [];

    api()
      .post('postChangePassword', {
        old_password: this.state.old_password,
        new_password: this.state.new_password,
        new_password_2: this.state.new_password_2,
      })
      .then(response => {
        errorMsg = [];
        errorBox = [];
        confirmBox = (
          <div className="alert alert-success">
            <strong>Änderung Erfolgreich!</strong>
            <br />
            Ihr Passwort wurde geändert.
          </div>
        );

        this.setState({ errorBox: errorBox, confirmBox: confirmBox, loading: false });
      })
      .catch(error => {
        errorMsg = [];

        if (error.response != null && error.response.data != null) {
          for (let item in error.response.data) {
            errorMsg.push(
              <p key={item}>
                {item}: {error.response.data[item]}
              </p>
            );
          }
        }

        confirmBox = [];
        errorBox = (
          <div className="alert alert-danger">
            <strong>Passwort konnte nicht geändert werden.</strong>
            <br />
            {errorMsg}
          </div>
        );

        this.setState({ errorBox: errorBox, confirmBox: confirmBox, loading: false });
      });
  }

  redirectBack(e) {
    window.history.back();
  }

  handleChange(e) {
    let value = e.target.value;
    this.setState({ [e.target.name]: value });
  }

  render() {
    return (
      <Header>
        <div className="page page__user_list">
          <Card>
            <h1>Passwort Ändern</h1>
            {this.state.errorBox}
            {this.state.confirmBox}
            <div className="container">
              <form
                id="changePasswordForm"
                className="form-horizontal"
                data-toggle="validator"
                onSubmit={e => {
                  e.preventDefault();
                  this.save();
                }}
              >
                <hr />
                <input name="id" value="00000" type="hidden" />
                <button type="button" name="back" className="btn btn-primary" onClick={e => this.redirectBack(e)}>
                  Abbrechen
                </button>
                <hr />

                <h3>Passwort</h3>

                <div className="form-group has-feedback">
                  <label className="control-label col-sm-3" htmlFor="old_password">
                    Altes Passwort
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="password"
                      id="old_password"
                      name="old_password"
                      value={this.state.old_password}
                      onChange={e => this.handleChange(e)}
                      className="form-control"
                      required
                      autoComplete="current-password"
                    />
                  </div>
                </div>

                <div className="form-group has-feedback">
                  <label className="control-label col-sm-3" htmlFor="old_password">
                    Neues Passwort
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="password"
                      id="new_password"
                      name="new_password"
                      value={this.state.new_password}
                      onChange={e => this.handleChange(e)}
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
                  <label className="control-label col-sm-3" htmlFor="old_password">
                    Wiederholen
                  </label>
                  <div className="col-sm-9">
                    <input
                      type="password"
                      id="new_password_2"
                      name="new_password_2"
                      value={this.state.new_password_2}
                      onChange={e => this.handleChange(e)}
                      className="form-control"
                      data-match="#new_password"
                      data-match-error="Die beiden Eingaben stimmen nicht überein"
                      placeholder=""
                      required
                      autoComplete="new-password"
                    />
                  </div>
                  <div className="col-sm-3" />
                  <div className="help-block with-errors col-sm-9" />
                </div>

                <button type="submit" className="btn btn-primary">
                  Absenden
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
    window.$('#changePasswordForm').validator();
  }
}
