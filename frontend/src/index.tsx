//tslint:disable:no-console
import * as React from 'react';
import * as ReactDOM from 'react-dom';
import App from './App';
import createBrowserHistory from 'history/createBrowserHistory';
import { Router } from 'react-router';
import * as Sentry from '@sentry/browser';
import { StoreProvider } from './utilities/StoreProvider';
import { ThemeProvider } from 'react-jss';
import { theme } from './layout/theme';

const browserHistory = createBrowserHistory();
const sentryDSN = 'SENTRY_DSN'; //this value will be replaced by a build script

if (sentryDSN.startsWith('https')) {
  console.log('yes raven');
  Sentry.init({ dsn: sentryDSN });
} else {
  console.log('no raven');
}

ReactDOM.render(
  <StoreProvider history={browserHistory}>
    <ThemeProvider theme={theme}>
      <Router history={browserHistory}>
        <App />
      </Router>
    </ThemeProvider>
  </StoreProvider>,
  document.getElementById('root') as HTMLElement
);
// registerServiceWorker();
