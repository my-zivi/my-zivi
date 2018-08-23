import React, { Component } from 'react';
import Card from '../tags/card';
import Header from '../tags/header';
import LoadingView from '../tags/loading-view';
import User from './profile/user';
import Commitment from './profile/commitment';

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
              <User onLoading={this.onLoading} onError={this.onError} userIdParam={userIdParam} />
              <hr />
              <Commitment onLoading={this.onLoading} onError={this.onError} userIdParam={userIdParam} />
            </div>
          </Card>

          <LoadingView loading={Object.values(this.state.loading).some(a => a)} error={this.state.error} />
        </div>
      </Header>
    );
  }
}
