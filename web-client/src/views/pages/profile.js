import React, { Component } from 'react';
import Card from '../tags/card';
import Header from '../tags/header';
import LoadingView from '../tags/loading-view';
import User from './profile/user';

export default class Profile extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: {},
      error: null,
    };

    this.onLoading = this.onLoading.bind(this);
    this.onError = this.onError.bind(this);
  }

  onLoading(component, state) {
    // must be in format { component: false / true }
    const { loading } = this.state;
    this.setState({
      loading: {
        ...loading,
        [component]: state,
      },
    });
  }

  onError(error) {
    this.setState({
      error: error,
    });
  }

  render() {
    const userIdParam = this.props.match.params.userid;

    return (
      <Header>
        <div className={'page page__user_list'}>
          <Card>
            <h1>Profil</h1>

            <div className={'container'}>
              <h3>Persönliche Informationen</h3>
              <p>
                Bitte fülle die folgenden Felder zu deiner Person wahrheitsgetreu aus. Dadurch erleichterst du dir und uns den
                administrativen Aufwand. Wir verwenden diese Informationen ausschliesslich zur Erstellung der Einsatzplanung und zur
                administrativen Abwicklung.
              </p>
              <p>
                Bitte lies dir auch die näheren Informationen zu den jeweiligen Feldern unter dem{' '}
                <span style={{ fontSize: '1em' }} className="glyphicon glyphicon-question-sign" aria-hidden="true" /> Icon jeweils durch.
              </p>
              <p>
                <b>Wichtig:</b> Vergiss nicht zu speichern (Daten speichern) bevor du die Seite verlässt oder eine Einsatzplanung erfasst.
              </p>
              <br />
              <User onLoading={this.onLoading} onError={this.onError} userIdParam={userIdParam} />
              <br /> <hr /> <br />
            </div>
          </Card>

          <LoadingView loading={Object.values(this.state.loading).some(a => a)} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
