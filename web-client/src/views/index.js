import Inferno from 'inferno';
import { Route } from 'inferno-router';
import Layout from './tags/layout';

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

const authorizedOnly = ({ router }) => {
  if (localStorage.getItem('jwtToken') === null) {
    router.push('/login?path=' + this.context.router.url);
  }
};

export default (
  <Route>
    <Route path="/" component={Home} />

    <Route path="/register" component={Register} />
    <Route path="/login" component={Login} />
    <Route path="/forgotPassword" component={ForgotPassword} />
    <Route path="/resetPassword/:code" component={ResetPassword} />
    <Route path="/logout" component={Logout} />

    <Route path="/profile/:userid?" component={Profile} onEnter={authorizedOnly} />

    <Route path="/changePassword" component={ChangePassword} onEnter={authorizedOnly} />

    <Route path="/user_list" component={UserList} onEnter={authorizedOnly} />
    <Route path="/user_phone_list" component={UserPhoneList} onEnter={authorizedOnly} />

    <Route path="/specification" component={Specification} onEnter={authorizedOnly} />
    <Route path="/freeday" component={Freeday} onEnter={authorizedOnly} />

    <Route path="/mission_overview" component={MissionOverview} onEnter={authorizedOnly} />

    <Route path="/expense" component={Expense} onEnter={authorizedOnly} />
    <Route path="/expensePayment" component={ExpensePayment} onEnter={authorizedOnly} />
    <Route path="/expensePayment/:payment_id" component={ExpensePaymentDetail} onEnter={authorizedOnly} />
    <Route path="/expense/:report_sheet_id" component={EditExpense} onEnter={authorizedOnly} />

    <Route path="/user_feedback/:missionId" component={UserFeedback} onEnter={authorizedOnly} />
    <Route path="/user_feedback_overview" component={UserFeedbackOverview} onEnter={authorizedOnly} />
    <Route path="/user_feedback_overview/:feedback_id" component={UserFeedbackOverview} onEnter={authorizedOnly} />

    <Route path="/help" component={Help} />

    <Route path="*" component={Error404} />
  </Route>
);
