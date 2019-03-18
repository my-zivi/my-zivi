import * as React from 'react';
import { UserUpdate } from './UserUpdate';
import { RouteComponentProps } from 'react-router';
import { inject } from 'mobx-react';
import { ApiStore } from '../../stores/apiStore';

interface ProfileOverviewProps extends RouteComponentProps {
  apiStore?: ApiStore;
}

@inject('apiStore')
class ProfileOverview extends React.Component<ProfileOverviewProps> {
  render(): React.ReactNode {
    return (
      <UserUpdate
        history={this.props.history}
        location={this.props.location}
        match={this.props.match}
        userId={this.props.apiStore!.userId}
      />
    );
  }
}

export { ProfileOverview };
