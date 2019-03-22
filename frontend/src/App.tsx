import 'bootstrap/dist/css/bootstrap.min.css';
import 'izitoast/dist/css/iziToast.css';
import * as React from 'react';
import 'react-widgets/dist/css/react-widgets.css';

import { Route, Switch } from 'react-router-dom';
import { IziviLayout } from './layout/IziviLayout';

import { Icons } from './utilities/Icon';
import { ProtectedRoute } from './utilities/ProtectedRoute';
import { ChangePassword } from './views/ChangePassword';
import { ForgotPassword } from './views/ForgotPassword';
import { HolidayOverview } from './views/Holiday';
import { Home } from './views/Home';
import { Login } from './views/Login';
import { MissionOverview } from './views/mission_overview/MissionOverview';
import { NotFound } from './views/NotFound';
import { PaymentDetail } from './views/payments/PaymentDetail';
import { PaymentOverview } from './views/payments/PaymentOverview';
import { PhoneListView } from './views/PhoneList';
import { Register } from './views/Register';
import { ReportSheetOverview } from './views/report_sheets/ReportSheetOverview';
import { ReportSheetUpdate } from './views/report_sheets/ReportSheetUpdate';
import { SpecificationsOverview } from './views/specification/SpecificationsOverview';
import { UserFeedbackOverview } from './views/user_feedback_overview/UserFeedbackOverview';
import { ProfileOverview } from './views/users/ProfileOverview';
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
          <Route component={Register} exact path={'/register'} />
          <Route component={ForgotPassword} exact path={'/forgotPassword'} />
          <Route component={HolidayOverview} exact path={'/holidays'} />
          <Route component={PhoneListView} exact path={'/phones'} />
          <Route component={ProfileOverview} exact path={'/profile'} />
          <ProtectedRoute component={ChangePassword} exact path={'/changePassword'} />
          <ProtectedRoute requiresAdmin component={PaymentOverview} exact path={'/payments'} />
          <ProtectedRoute requiresAdmin component={MissionOverview} exact path={'/missions'} />
          <ProtectedRoute requiresAdmin component={PaymentDetail} exact path={'/payments/:id'} />
          <ProtectedRoute requiresAdmin component={ReportSheetOverview} exact path={'/report_sheets'} />
          <ProtectedRoute requiresAdmin component={ReportSheetUpdate} exact path={'/report_sheets/:id'} />
          <ProtectedRoute requiresAdmin component={UserFeedbackOverview} exact path={'/user_feedbacks'} />
          <ProtectedRoute requiresAdmin component={UserOverview} exact path={'/users'} />
          <ProtectedRoute requiresAdmin component={UserUpdate} exact path={'/users/:id'} />
          <ProtectedRoute requiresAdmin component={SpecificationsOverview} exact path={'/specifications'} />
          <Route component={NotFound} />
        </Switch>
      </IziviLayout>
    );
  }
}

export default App;
