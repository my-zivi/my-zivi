import Inferno from 'inferno';
import { Route } from 'inferno-router';
import Layout from './tags/layout';

import { connect } from 'inferno-mobx';

import Home from './pages/home';
import Register from './pages/register';
import Login from './pages/login';
import Logout from './pages/logout';

import Profile from './pages/profile';

import UserList from './pages/user_list';
import UserPhoneList from './pages/user_phone_list';

import Specification from './pages/specification';
import Freeday from './pages/freeday';

import MissionOverview from './pages/mission_overview';
import Expense from './pages/expense';

import Help from './pages/help';

import Error404 from './pages/errors/404';

const authorizedOnly = ({ router }) => {
  if (localStorage.getItem('jwtToken') === null) {
    router.push('/login');
  } else {
    // verify token is valid and has not expired yet and set props isLoggedIn and maybe also isAdmin and Role
  }
};

export default (
  <Route component={Layout}>
    <Route path="/" component={Home} />

    <Route path="/register" component={Register} />
    <Route path="/login" component={Login} />
    <Route path="/logout" component={Logout} />

    <Route path="/profile" component={Profile} onEnter={authorizedOnly} />

    <Route path="/user_list" component={UserList} onEnter={authorizedOnly} />
    <Route path="/user_phone_list" component={UserPhoneList} onEnter={authorizedOnly} />

    <Route path="/specification" component={Specification} onEnter={authorizedOnly} />
    <Route path="/freeday" component={Freeday} onEnter={authorizedOnly} />

    <Route path="/mission_overview" component={MissionOverview} onEnter={authorizedOnly} />
    <Route path="/expense" component={Expense} onEnter={authorizedOnly} />

    <Route path="/help" component={Help} />

    <Route path="*" component={Error404} />
  </Route>
);
