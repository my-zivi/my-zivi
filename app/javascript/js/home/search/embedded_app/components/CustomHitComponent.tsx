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

type ClickHandler = (hit: JobPostingSearchHit) => void;

const renderHits = (hits: JobPostingSearchHit[], onclick: ClickHandler) => (
  hits.map((hit) => {
    const props = {
      onclick: () => onclick(hit),
      hit,
    };

    return (
      <div className="col-12 col-xl-6 mb-4">
        <JobPosting key={hit.objectID} {...(props as never)} />
      </div>
    );
  })
);

type Props = InfiniteHitsProvided & { onclick: ClickHandler };
const Hits: ComponentType<Props> = ({
  hits, hasMore, refineNext, onclick,
}) => (
  <div className="row">
    {isEmpty(hits) ? <NoResults /> : renderHits(hits, onclick)}
    {hasMore && (
      <div className="col-12 text-center mt-3">
        <button className="btn btn-link" onClick={refineNext}>{MyZivi.translations.search.loadMore}</button>
      </div>
    )}
  </div>
);

export default connectInfiniteHits<Props, JobPostingSearchHit>(Hits);
