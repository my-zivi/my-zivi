import * as React from 'react';
import { inject, observer } from 'mobx-react';
import { RouteComponentProps } from 'react-router';
import { FormValues, User } from '../../types';
import { toJS } from 'mobx';
import { UserForm } from './UserForm';
import { UserStore } from '../../stores/userStore';

interface UserDetailRouterProps {
  id?: string;
}

interface Props extends RouteComponentProps<UserDetailRouterProps> {
  userStore?: UserStore;
  userId?: number;
}

@inject('userStore')
@observer
export class UserUpdate extends React.Component<Props> {
  constructor(props: Props) {
    super(props);
    if (props.userId) {
      props.userStore!.fetchOne(props.userId);
    } else {
      props.userStore!.fetchOne(Number(props.match.params.id));
    }
  }

  public handleSubmit = (user: User) => {
    return this.props.userStore!.put(user);
  };

  public get user() {
    const user = this.props.userStore!.user;
    if (user) {
      return toJS(user);
      //it's important to detach the mobx proxy before passing it into formik - formik's deepClone can fall into endless recursions with those proxies.
    } else {
      return undefined;
    }
  }

  public render() {
    const user = this.user;

    return <UserForm onSubmit={this.handleSubmit} user={user as FormValues} title={user ? `Profil` : 'Profil wird geladen'} />;
  }
}
