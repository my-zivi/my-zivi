import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { Redirect, Route, RouteComponentProps, RouteProps } from 'react-router';
import { ApiStore } from '../stores/apiStore';

interface ProtectedRouteProps extends RouteProps {
  apiStore?: ApiStore;
  component: React.ComponentType<RouteComponentProps<any>> | React.ComponentType<any>; // tslint:disable-line
  requiresAdmin?: boolean;
}

@inject('apiStore')
@observer
export class ProtectedRoute extends React.Component<ProtectedRouteProps> {
  public protect = (props: RouteComponentProps) => {
    const login = {
      pathname: '/login',
      state: { referrer: props.location!.pathname },
    };

    const siteNotFound = {
      pathname: '/404',
      state: { referrer: props.location!.pathname },
    };

    const Component = this.props.component;
    const apiStore = this.props.apiStore!;

    if (apiStore.isLoggedIn) {
      if (this.props.requiresAdmin && !apiStore.isAdmin) {
        return <Redirect to={siteNotFound} />;
      } else {
        return <Component {...props} />;
      }
    } else {
      apiStore.logout(false);
      return <Redirect to={login} />;
    }
  };

  public render() {
    return <Route {...this.props} component={undefined} render={this.protect} />;
  }
}
