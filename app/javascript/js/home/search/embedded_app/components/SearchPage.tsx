import { Configure, InstantSearch, Stats } from 'react-instantsearch-dom';
import CustomAutocomplete from 'js/home/search/embedded_app/components/CustomAutocomplete';
import CustomHitComponent from 'js/home/search/embedded_app/components/CustomHitComponent';
import RefinementsPanel from 'js/home/search/embedded_app/components/RefinementsPanel';
import React, { JSX } from 'preact/compat';
import { SearchClient } from 'algoliasearch';
import PoweredBy from 'js/home/search/embedded_app/components/PoweredBy';
import qs from 'qs';
import aa from 'search-insights';

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
        <Configure hitsPerPage={HITS_PER_PAGE} />
        <Configure clickAnalytics />
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

          <div className="container mt-6">
            <div className="d-flex justify-content-start justify-content-lg-end mb-2">
              <div className="text-muted mr-1">
                <Stats translations={{
                  stats(hitsCount, processingTimeMS) {
                    return MyZivi.translations.search.statistics
                      .replace('%{count}', hitsCount.toLocaleString())
                      .replace('%{time}', processingTimeMS.toLocaleString());
                  },
                }} />
              </div>
              <PoweredBy />
            </div>
            <div className="row">
              <div className="col-12 col-lg-9 order-1 order-lg-0">
                <section className="jobs-hits pt-0">
                  <CustomHitComponent />
                </section>
              </div>
              <div className="col-12 col-lg-3 order-0 order-lg-1">
                <RefinementsPanel />
              </div>
            </div>
          </div>
        </div>
      </InstantSearch>
    );
  }
}

export default SearchPage;
