import * as React from 'react';
import './App.css';
import { Route, Switch } from 'react-router-dom';
import { IziviLayout } from './IziviLayout';

import 'bootstrap/dist/css/bootstrap.min.css';
import { Home } from './views/Home';

class App extends React.Component {
  public render() {
    return (
      <IziviLayout>
        <Switch>
          <Route component={Home} />
          <Route>
            <>404</>
          </Route>
        </Switch>
      </IziviLayout>
    );
  }
}

export default App;
