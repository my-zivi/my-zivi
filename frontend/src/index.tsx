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
import moment from 'moment';
import 'moment/locale/de-ch';
import momentLocalizer from 'react-widgets-moment';

const browserHistory = createBrowserHistory();
const sentryDSN = 'SENTRY_DSN'; //this value will be replaced by a build script

if (sentryDSN.startsWith('https')) {
  console.log('yes raven');
  Sentry.init({ dsn: sentryDSN });
} else {
  console.log('no raven');
}

moment.locale('de-ch');
momentLocalizer();

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
