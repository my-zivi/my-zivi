import { ComponentType } from 'preact';
import { InfiniteHitsProvided } from 'react-instantsearch-core';
import React from 'preact/compat';
import { connectInfiniteHits } from 'react-instantsearch-dom';
import { isEmpty } from 'lodash';
import { JobPostingSearchHit } from 'js/home/search/embedded_app/types';
import JobPosting from './JobPosting';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const noResultsImage = require('../../../../../images/home/no-results.svg');

const NoResults: React.FunctionComponent = () => (
  <div className="d-flex flex-column align-items-center w-100 mt-4">
    <img src={noResultsImage} alt={MyZivi.translations.search.noResultsFound} className="w-25" />
    <h3 className="text-muted mt-4">{MyZivi.translations.search.noResultsFound}</h3>
  </div>
);

const renderHits = (hits: JobPostingSearchHit[]) => (
  hits.map((hit) => (
    <div className="col-12 col-xl-6 mb-4">
      <JobPosting hit={hit} key={hit.objectID} />
    </div>
  ))
);

const Hits: ComponentType<InfiniteHitsProvided> = ({ hits, hasMore, refineNext }) => (
  <div className="row">
    {isEmpty(hits) ? <NoResults /> : renderHits(hits)}
    {hasMore && (
      <div className="col-12 text-center mt-3">
        <button className="btn btn-link" onClick={refineNext}>{MyZivi.translations.search.loadMore}</button>
      </div>
    )}
  </div>
);

export default connectInfiniteHits(Hits);
