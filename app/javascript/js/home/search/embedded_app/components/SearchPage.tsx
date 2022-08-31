import { Configure, InstantSearch, Stats } from 'react-instantsearch-dom';
import CustomAutocomplete from 'js/home/search/embedded_app/components/CustomAutocomplete';
import React, { JSX } from 'preact/compat';
import { SearchClient } from 'algoliasearch';
import qs from 'qs';
import MapSearchView from 'js/home/search/embedded_app/components/MapSearchView';
import TilesSearchView from 'js/home/search/embedded_app/components/TilesSearchView';

const HITS_PER_PAGE = 20;

type SearchState = Record<string, unknown>;
type Props = { searchClient: SearchClient };
type State = { searchState: SearchState };

const searchStateToUrl = (searchState: SearchState) => (searchState ? `?${qs.stringify(searchState)}` : '');
const urlToSearchState = (search: string) => qs.parse(search.slice(1));

class SearchPage extends React.Component<Props, State> {
  constructor() {
    super();

    this.state = {
      searchState: urlToSearchState(window.location.search),
    };
  }

  private onSearchStateChange: (searchState: SearchState) => void = (searchState) => {
    window.history.replaceState(null, null, searchStateToUrl(searchState));

    this.setState({ searchState });
  };

  render(): JSX.Element {
    const { searchClient } = this.props;
    const defaultRefinement = new URLSearchParams(window.location.search).get('q');

    return (
      <InstantSearch
        searchClient={searchClient}
        onSearchStateChange={this.onSearchStateChange}
        searchState={this.state.searchState}
        indexName="JobPosting"
      >
        <Configure hitsPerPage={HITS_PER_PAGE} clickAnalytics />
        <div className="search-main">
          <div className="hero">
            <div className="container">
              <div className="hero-content w-100">
                <div className="row">
                  <div className="col-xl-1" />
                  <div className="col"><CustomAutocomplete defaultRefinement={defaultRefinement} /></div>
                  <div className="col-xl-1" />
                </div>
              </div>
            </div>
          </div>

          <MapSearchView />
          {/*<TilesSearchView />*/}
        </div>
      </InstantSearch>
    );
  }
}

export default SearchPage;
