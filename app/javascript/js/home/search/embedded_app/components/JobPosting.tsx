import React from 'preact/compat';
import { JobPostingSearchHit } from 'js/home/search/embedded_app/types';
import Ribbon from 'js/home/search/embedded_app/components/Ribbon';
import { connectHitInsights, WrappedInsightsClient } from 'react-instantsearch-core';
import aa from 'search-insights';
import { Hit } from '@algolia/client-search';

const JobPostingIcon = React.memo((({ iconUrl, alt }) => (
  <img src={iconUrl} alt={alt} className="job-posting-icon" />
)) as React.FunctionComponent<{ iconUrl: string, alt: string }>);

type Props = { hit: Hit<JobPostingSearchHit>, insights: WrappedInsightsClient };
const JobPosting: React.FunctionComponent<Props> = (props) => {
  const { hit, insights } = props;

  return (
    <a href={hit.link} onClick={(event: MouseEvent) => {
      event.stopImmediatePropagation();
      event.preventDefault();

      insights('clickedObjectIDsAfterSearch', {
        eventName: 'JobPosting Clicked',
      });

      // FIXME: Since Turbo.visit(..., { action: 'replace' }) actually loads and replaces the page,
      // the React app would be mounted and re-rendered causing a flash of all the content. Hence, we need to use
      // window.history.replaceState directly, but this is not supported by Turbo. To make Turbo know the page we
      // left, we call the internal update method of the Turbo.Navigator and inject the location into the state.
      const { Turbo: { navigator } } = window;
      navigator.history.update(window.history.replaceState, window.location, navigator.history.restorationIdentifier);

      window.Turbo.visit(hit.link);
    }}>
      <div className="card h-100 job-posting-card">
        <Ribbon hit={hit} />
        <div className="card-body">
          <div className="d-flex flex-column">
            <div className="icon-container">
              <JobPostingIcon iconUrl={hit.icon_url} alt={hit.organization_display_name} key={hit.icon_url} />
              <h6 className="job-posting-subtitle">{hit.organization_display_name}</h6>
            </div>
            <div className="job-posting-card-content">
              <h5 className="job-posting-title">{hit.title}</h5>
              <div className="job-description">{hit.brief_description}</div>
            </div>
          </div>
        </div>
      </div>
    </a>
  );
};

export default connectHitInsights(aa)(JobPosting);
