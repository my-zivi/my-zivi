import { toJS } from 'mobx';
import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { RouteComponentProps } from 'react-router';
import { UserStore } from '../../stores/userStore';
import { FormValues, User } from '../../types';
import { UserForm } from './UserForm';

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

    props.userStore!.fetchOne(props.userId ? props.userId : Number(props.match.params.id));
  }

  handleSubmit = (user: User) => {
    return this.props.userStore!.put(user);
  }

  get user() {
    const user = this.props.userStore!.user;
    if (user) {
      return toJS(user);
      // it's important to detach the mobx proxy before passing it into formik
      // formik's deepClone can fall into endless recursions with those proxies.
    } else {
      return undefined;
    }
  }

  render() {
    const user = this.user;

    return <UserForm onSubmit={this.handleSubmit} user={user as FormValues} title={user ? 'Profil' : 'Profil wird geladen'} />;
  }
}
