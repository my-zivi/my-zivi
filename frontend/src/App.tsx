import * as React from 'react';
import { Route, Switch } from 'react-router-dom';
import { IziviLayout } from './layout/IziviLayout';

import 'bootstrap/dist/css/bootstrap.min.css';
import { Home } from './views/Home';
import { Login } from './views/Login';

class App extends React.Component {
  public render() {
    return (
      <IziviLayout>
        <Switch>
          <Route component={Home} exact path={'/'} />
          <Route component={Login} exact path={'/login'} />
          <Route>
            <>404</>
          </Route>
        </Switch>
      </IziviLayout>
    );
  }
}

export default App;
