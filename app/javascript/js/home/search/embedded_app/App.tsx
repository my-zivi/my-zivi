import algoliasearch from 'algoliasearch';
import React from 'preact/compat';
import { createBrowserLocalStorageCache } from '@algolia/cache-browser-local-storage';
import { createFallbackableCache } from '@algolia/cache-common';
import { createInMemoryCache } from '@algolia/cache-in-memory';
import aa from 'search-insights';
import Turbo from '@hotwired/turbo-rails';
import SearchPage from '~/js/home/search/embedded_app/components/SearchPage';

declare global {
  interface Window {
    Turbo: typeof Turbo;
  }
}

aa('init', {
  appId: MyZivi.algolia.applicationId,
  apiKey: MyZivi.algolia.apiKey,
  useCookie: true,
});

const searchClient = algoliasearch(
  MyZivi.algolia.applicationId,
  MyZivi.algolia.apiKey,
  {
    responsesCache: createFallbackableCache({
      caches: [
        createBrowserLocalStorageCache({ key: 'my-zivi-search', localStorage: window.sessionStorage }),
        createInMemoryCache(),
      ],
    }),
    requestsCache: createInMemoryCache({ serializable: false }),
  },
);

const App: React.FunctionComponent = () => (
  <SearchPage searchClient={searchClient} />
);

export default App;
