import React from 'react';
import { Redirect, Route, Switch } from 'react-router-dom';

import Auth from '../utils/auth';

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
import ExpensePayment from './pages/expense_payment';
import ExpensePaymentDetail from './pages/expense_payment_detail';
import EditExpense from './pages/edit_expense';

import UserFeedback from './pages/user_feedback';
import UserFeedbackOverview from './pages/user_feedback_overview';

import Help from './pages/help';

import Error404 from './pages/errors/404';
import ChangePassword from './pages/changePassword';
import ForgotPassword from './pages/forgotPassword';
import ResetPassword from './pages/resetPassword';

function ProtectedRoute({ component: Component, ...props }) {
  let render = props => {
    let target = {
      pathname: '/login',
      state: { referrer: props.location.pathname },
    };
    return Auth.isLoggedIn() ? <Component {...props} /> : <Redirect to={target} />;
  };

  return <Route {...props} render={render} />;
}

export default (
  <div>
    <Switch>
      <Route exact path="/" component={Home} />

      <Route path="/register" component={Register} />
      <Route path="/login" component={Login} />
      <Route path="/forgotPassword" component={ForgotPassword} />
      <Route path="/resetPassword/:code" component={ResetPassword} />
      <Route path="/logout" component={Logout} />

      <ProtectedRoute path="/profile/:userid?" component={Profile} />

      <ProtectedRoute path="/changePassword" component={ChangePassword} />

      <ProtectedRoute path="/user_list" component={UserList} />
      <ProtectedRoute path="/user_phone_list" component={UserPhoneList} />

      <ProtectedRoute path="/specification" component={Specification} />
      <ProtectedRoute path="/freeday" component={Freeday} />

      <ProtectedRoute path="/mission_overview" component={MissionOverview} />

      <ProtectedRoute path="/expense" exact component={Expense} />
      <ProtectedRoute path="/expensePayment" exact component={ExpensePayment} />
      <ProtectedRoute path="/expensePayment/:payment_id" component={ExpensePaymentDetail} />
      <ProtectedRoute path="/expense/:report_sheet_id" component={EditExpense} />

      <ProtectedRoute path="/user_feedback/:missionId" component={UserFeedback} />
      <ProtectedRoute path="/user_feedback_overview" exact component={UserFeedbackOverview} />
      <ProtectedRoute path="/user_feedback_overview/:feedback_id" component={UserFeedbackOverview} />

      <Route path="/help" component={Help} />

      <Route component={Error404} />
    </Switch>
  </div>
);
