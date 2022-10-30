import { InstantSearch } from 'react-instantsearch-dom';
import CustomAutocomplete from 'js/home/search/embedded_app/components/CustomAutocomplete';
import React, { JSX } from 'preact/compat';
import { SearchClient } from 'algoliasearch';
import qs from 'qs';
import MapSearchView from 'js/home/search/embedded_app/components/MapSearchView';
import SearchViewSwitch, { SearchView } from 'js/home/search/embedded_app/components/SearchViewSwitch';
import TilesSearchView from 'js/home/search/embedded_app/components/TilesSearchView';

type SearchState = Record<string, unknown>;
type Props = { searchClient: SearchClient };
type State = { searchState: SearchState, activeView: SearchView };

const parseQueryString = (search: string) => {
  try {
    return qs.parse(search.slice(1));
  } catch (e) {
    return {};
  }
};

class SearchPage extends React.Component<Props, State> {
  constructor() {
    super();

    const query = parseQueryString(window.location.search);
    const activeView = Object.values(SearchView).includes(query.view as SearchView)
      ? (query.view as SearchView)
      : SearchView.Tiles;

    this.state = {
      searchState: (query.s || {}) as SearchState,
      activeView,
    };
  }

  componentDidUpdate() {
    const queryState = {
      s: this.state.searchState,
      view: this.state.activeView,
    };
    window.history.replaceState(null, null, `?${qs.stringify(queryState)}`);
  }

  private getCurrentSearchView = (): JSX.Element => {
    switch (this.state.activeView) {
      case SearchView.Tiles:
        return <TilesSearchView />;
      case SearchView.Map:
        return <MapSearchView />;
      default:
        return null;
    }
  };

  render(): JSX.Element {
    const { searchClient } = this.props;
    const defaultRefinement = new URLSearchParams(window.location.search).get('q');

    return (
      <InstantSearch
        searchClient={searchClient}
        onSearchStateChange={(searchState: SearchState) => this.setState({ searchState })}
        searchState={this.state.searchState}
        indexName="JobPosting"
      >
        <div className="search-main">
          <div className="hero">
            <div className="container">
              <div className="hero-content narrow w-100">
                <div className="row">
                  <div className="col-xl-1" />
                  <div className="col"><CustomAutocomplete defaultRefinement={defaultRefinement} /></div>
                  <div className="col-xl-1" />
                </div>
              </div>
            </div>
          </div>

          <div className="position-relative">
            <SearchViewSwitch
              activeView={this.state.activeView}
              onChange={(activeView: SearchView) => this.setState({ activeView })}
            />
            {this.getCurrentSearchView()}
          </div>
        </div>
      </InstantSearch>
    );
  }
}

export default SearchPage;
