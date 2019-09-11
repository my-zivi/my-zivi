import 'bootstrap/dist/css/bootstrap.min.css';
import 'izitoast/dist/css/iziToast.css';
import * as React from 'react';
import 'react-widgets/dist/css/react-widgets.css';

import { Route, Switch } from 'react-router-dom';
import { IziviLayout } from './layout/IziviLayout';

import { Icons } from './utilities/Icon';
import { ProtectedRoute } from './utilities/ProtectedRoute';
import { ChangeForgottenPassword } from './views/ChangeForgottenPassword';
import { ChangePassword } from './views/ChangePassword';
import { ExpenseSheetOverview } from './views/expense_sheets/ExpenseSheetOverview';
import { ExpenseSheetUpdate } from './views/expense_sheets/ExpenseSheetUpdate';
import { ForgotPassword } from './views/ForgotPassword';
import { HolidayOverview } from './views/holidays/HolidayOverview';
import { Home } from './views/Home';
import { Login } from './views/Login';
import { NotFound } from './views/NotFound';
import { PaymentDetail } from './views/payments/detail/PaymentDetail';
import { PaymentOverview } from './views/payments/PaymentOverview';
import { PhoneListView } from './views/PhoneList';
import { Register } from './views/register/Register';
import { ServiceOverview } from './views/service_overview/ServiceOverview';
import { ServiceSpecificationsOverview } from './views/service_specification/ServiceSpecificationsOverview';
import { UserFeedbackOverview } from './views/user_feedback_overview/UserFeedbackOverview';
import { ProfileOverview } from './views/users/ProfileOverview';
import { ServiceFeedback } from './views/users/service_feedback/ServiceFeedback';
import { UserOverview } from './views/users/UserOverview';
import { UserUpdate } from './views/users/UserUpdate';

Icons();

class App extends React.Component {
  render() {
    return (
      <IziviLayout>
        <Switch>
          <Route component={Home} exact path={'/'} />
          <Route component={Login} exact path={'/login'} />
          <Route component={Register} exact path={'/register/:page'} />
          <Route component={ForgotPassword} exact path={'/users/password/reset'} />
          <Route component={ChangeForgottenPassword} exact path={'/users/password/edit/:reset_password_token'} />
          <Route component={HolidayOverview} exact path={'/holidays'} />
          <Route component={PhoneListView} exact path={'/phones'} />
          <Route component={ProfileOverview} exact path={'/profile'} />
          <ProtectedRoute component={ChangePassword} exact path={'/changePassword'} />
          <ProtectedRoute requiresAdmin component={PaymentOverview} exact path={'/payments'} />
          <ProtectedRoute requiresAdmin component={ServiceOverview} exact path={'/services'} />
          <ProtectedRoute requiresAdmin component={PaymentDetail} exact path={'/payments/:timestamp'} />
          <ProtectedRoute requiresAdmin component={ExpenseSheetOverview} exact path={'/expense_sheets'} />
          <ProtectedRoute requiresAdmin component={ExpenseSheetUpdate} exact path={'/expense_sheets/:id'} />
          <ProtectedRoute requiresAdmin component={UserFeedbackOverview} exact path={'/user_feedbacks'} />
          <ProtectedRoute requiresAdmin component={UserOverview} exact path={'/users'} />
          <ProtectedRoute requiresAdmin component={UserUpdate} exact path={'/users/:id'} />
          <ProtectedRoute requiresAdmin component={ServiceSpecificationsOverview} exact path={'/service_specifications'} />
          <Route component={NotFound} />
        </Switch>
      </IziviLayout>
    );
  }
}

export default App;
