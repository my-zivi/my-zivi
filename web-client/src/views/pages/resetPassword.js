import { Component } from 'inferno';
import Card from '../tags/card';
import LoadingView from '../tags/loading-view';
import Header from '../tags/header';
import { api } from '../../utils/api';

export default class ResetPassword extends Component {
  constructor(props) {
    super(props);

    this.state = {
      new_password: '',
      new_password_2: '',
      done: false,
    };
  }

  save() {
    this.setState({ loading: true, error: null });
    let errorMsg = [];
    let errorBox = [];
    let confirmBox = [];

    api()
      .post('auth/resetPassword', {
        code: this.props.match.params.code,
        new_password: this.state.new_password,
        new_password_2: this.state.new_password_2,
      })
      .then(response => {
        errorMsg = [];
        errorBox = [];
        confirmBox = (
          <div className="alert alert-success">
            <strong>Änderung Erfolgreich!</strong>
            <br />Ihr Passwort wurde geändert. <a href="/login">Zum Login</a>
          </div>
        );

        this.setState({ done: true, errorBox: errorBox, confirmBox: confirmBox, loading: false });
      })
      .catch(error => {
        errorMsg = [];

        if (error.response != null && error.response.data != null) {
          for (let item in error.response.data) {
            errorMsg.push(<p>{error.response.data[item]}</p>);
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
    this.setState({
      [e.target.name]: value,
    });
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
              {!this.state.done && (
                <form
                  id="changePasswordForm"
                  className="form-horizontal"
                  data-toggle="validator"
                  onSubmit={e => {
                    e.preventDefault();
                    this.save();
                  }}
                >
                  <div className="form-group has-feedback">
                    <label className="control-label col-sm-3" for="old_password">
                      Neues Passwort
                    </label>
                    <div className="col-sm-9">
                      <input
                        type="password"
                        id="new_password"
                        name="new_password"
                        value={this.state.new_password}
                        onInput={e => this.handleChange(e)}
                        className="form-control"
                        data-minlength="7"
                        placeholder=""
                        required
                      />
                    </div>
                    <div className="col-sm-3" />
                    <div className="help-block col-sm-9">Mindestens 7 Zeichen</div>
                  </div>

                  <div className="form-group has-feedback">
                    <label className="control-label col-sm-3" for="old_password">
                      Wiederholen
                    </label>
                    <div className="col-sm-9">
                      <input
                        type="password"
                        id="new_password_2"
                        name="new_password_2"
                        value={this.state.new_password_2}
                        onInput={e => this.handleChange(e)}
                        className="form-control"
                        data-match="#new_password"
                        data-match-error="Die beiden Eingaben stimmen nicht überein"
                        placeholder=""
                        required
                      />
                    </div>
                    <div className="col-sm-3" />
                    <div className="help-block with-errors col-sm-9" />
                  </div>

                  <button type="submit" className="btn btn-primary">
                    Absenden
                  </button>
                </form>
              )}
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
