import 'babel-polyfill';
import Inferno from 'inferno';
import { Router } from 'inferno-router';
import { createBrowserHistory } from 'history';
import views from './views';
import './index.sass';
import 'bootstrap/dist/css/bootstrap.css';
import 'izitoast/dist/css/iziToast.css';
import Raven from 'raven-js';
import api from './utils/auth';

//these will be replaced by a build script, if needed
export const release = 'COMMIT_ID';
export const environment = 'ENVIRONMENT';
const sentryDSN = 'SENTRY_DSN';

if (sentryDSN.startsWith('https')) {
  console.log('yes raven');
  Raven.config(sentryDSN).install();
} else {
  console.log('no raven');
}

Raven.context(() => {
  Raven.setTagsContext({ release });
  Raven.setUserContext({ id: api.getUserId() });

  const browserHistory = createBrowserHistory();

  Inferno.render(<Router history={browserHistory}>{views}</Router>, document.getElementById('root'));
});

if (process.env.NODE_ENV === 'production') {
  if ('serviceWorker' in navigator && location.protocol === 'https:') {
    // disable serviceworker, it seems to make more trouble than help
    //navigator.serviceWorker.register('/service-worker.js');
  }

  /* 	// add Google Analytics
	(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
	ga('create', 'UA-XXXXXXXX-X', 'auto');
	ga('send', 'pageview');

	// track pages on route change
	window.ga && history.listen(obj => ga('send', 'pageview', obj.pathname)); */
}
