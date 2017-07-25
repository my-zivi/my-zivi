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
  // console.log('Start!');
  // if (localStorage.getItem("jwtToken") === null) {
  // 	console.log('No valid token found!');
  // 	router.push('/blog');
  // };
  // console.log('Token exists, but valid?');
  // console.log('Finish!');
};

const doLogout = ({ router }) => {
  localStorage.removeItem('jwtToken');
  console.log('GO');
  connect(
    props => {
      console.log(props);
    },
    props => {
      props.accountStore.isLoggedIn = false;
    },
    props => {
      props.accountStore.isAdmin = false;
    }
  ),
    props => {
      console.log(props);
    };
  connect(props => {
    console.log(props);
  });
  //this.props.accountStore.isLoggedIn = false
  //this.props.accountStore.isAdmin = false
  console.log('STOP');

  router.push('/');
};

export default (
  <Route component={Layout} onEnter={authorizedOnly}>
    <Route path="/" component={Home} />

    <Route path="/register" component={Register} />
    <Route path="/login" component={Login} />
    <Route path="/logout" component={Logout} onEnter={doLogout} />

    <Route path="/profile" component={Profile} />

    <Route path="/user_list" component={UserList} />
    <Route path="/user_phone_list" component={UserPhoneList} />

    <Route path="/specification" component={Specification} />
    <Route path="/freeday" component={Freeday} />

    <Route path="/mission_overview" component={MissionOverview} />
    <Route path="/expense" component={Expense} />

    <Route path="/help" component={Help} />

    <Route path="*" component={Error404} />
  </Route>
);
