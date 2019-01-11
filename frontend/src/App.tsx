import * as React from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'izitoast/dist/css/iziToast.css';
import 'react-widgets/dist/css/react-widgets.css';

import { Route, Switch } from 'react-router-dom';
import { IziviLayout } from './layout/IziviLayout';

import { Home } from './views/Home';
import { Login } from './views/Login';
import { ForgotPassword } from './views/ForgotPassword';
import { PhoneListView } from './views/PhoneList';
import { HolidayOverview } from './views/Holiday';
import { ProtectedRoute } from './utilities/ProtectedRoute';
import { ReportSheetUpdate } from './views/report_sheets/ReportSheetUpdate';
import { NotFound } from './views/NotFound';

class App extends React.Component {
  public render() {
    return (
      <IziviLayout>
        <Switch>
          <Route component={Home} exact path={'/'} />
          <Route component={Login} exact path={'/login'} />
          <Route component={ForgotPassword} exact path={'/forgotPassword'} />
          <Route component={HolidayOverview} exact path={'/holidays'} />
          <Route component={PhoneListView} exact path={'/phones'} />
          <ProtectedRoute requiresAdmin component={ReportSheetUpdate} exact path={'/report_sheets/:id'} />
          <Route component={NotFound} />
        </Switch>
      </IziviLayout>
    );
  }
}

export default App;
