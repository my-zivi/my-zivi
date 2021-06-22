import algoliasearch from 'algoliasearch';
import React from 'preact/compat';
import { createBrowserLocalStorageCache } from '@algolia/cache-browser-local-storage';
import { createFallbackableCache } from '@algolia/cache-common';
import { createInMemoryCache } from '@algolia/cache-in-memory';
import SearchPage from 'js/home/search/embedded_app/components/SearchPage';

const searchClient = algoliasearch(
  MyZivi.algolia.applicationId,
  MyZivi.algolia.apiKey,
  {
    responsesCache: createFallbackableCache({
      caches: [
        createBrowserLocalStorageCache({ key: 'my-zivi-search' }),
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
