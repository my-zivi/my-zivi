import * as React from 'react';
import { UserOverview } from './UserOverview';

interface ProfileOverviewProps {}

class ProfileOverview extends React.Component<ProfileOverviewProps> {
  componentDidMount(): void {}

  render(): React.ReactNode {
    return <UserOverview />;
  }
}

export { ProfileOverview };
