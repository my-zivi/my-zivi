import Inferno from 'inferno';
import { Router } from 'inferno-router';
import { Provider } from 'inferno-mobx';
import { createBrowserHistory } from 'history';
import { observable } from 'mobx';
import views from './views';
import './index.sass';

const browserHistory = createBrowserHistory();

const accountStore = observable({
  email: null,
  isLoggedIn: false,
  isAdmin: false,
});

Inferno.render(
  <Provider accountStore={accountStore}>
    <Router history={browserHistory}>{views}</Router>
  </Provider>,
  document.getElementById('root')
);

if (process.env.NODE_ENV === 'production') {
  // cache all assets if browser supports serviceworker
  if ('serviceWorker' in navigator && location.protocol === 'https:') {
    navigator.serviceWorker.register('/service-worker.js');
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
