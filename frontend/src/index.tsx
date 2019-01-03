import * as React from 'react';
import * as ReactDOM from 'react-dom';
import App from './App';
import './index.css';
import createBrowserHistory from 'history/createBrowserHistory';
import { Router } from 'react-router';
import * as Sentry from '@sentry/browser';

const browserHistory = createBrowserHistory();
const sentryDSN = 'SENTRY_DSN'; //this value will be replaced by a build script

if (sentryDSN.startsWith('https')) {
  console.log('yes raven');
  Sentry.init({ dsn: sentryDSN });
} else {
  console.log('no raven');
}

ReactDOM.render(
  <Router history={browserHistory}>
    <App />
  </Router>,
  document.getElementById('root') as HTMLElement
);
// registerServiceWorker();
