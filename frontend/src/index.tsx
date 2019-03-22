// tslint:disable:no-console
import * as Sentry from '@sentry/browser';
import createBrowserHistory from 'history/createBrowserHistory';
import moment from 'moment';
import 'moment/locale/de-ch';
import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { ThemeProvider } from 'react-jss';
import { Router } from 'react-router';
import momentLocalizer from 'react-widgets-moment';
import App from './App';
import { theme } from './layout/theme';
import { StoreProvider } from './utilities/StoreProvider';

const browserHistory = createBrowserHistory();
const sentryDSN = 'SENTRY_DSN'; // this value will be replaced by a build script

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
  document.getElementById('root') as HTMLElement,
);
// registerServiceWorker();
