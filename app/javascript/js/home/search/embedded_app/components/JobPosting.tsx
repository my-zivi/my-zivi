import React from 'preact/compat';
import { JobPostingSearchHit } from 'js/home/search/embedded_app/types';
import Ribbon from 'js/home/search/embedded_app/components/Ribbon';
import { connectHitInsights, WrappedInsightsClient } from 'react-instantsearch-core';
import aa from 'search-insights';
import { Hit } from '@algolia/client-search';

const JobPostingIcon = React.memo((({ iconUrl, alt }) => (
  <img src={iconUrl} alt={alt} className="job-posting-icon" />
)) as React.FunctionComponent<{ iconUrl: string, alt: string }>);

interface Props {
  hit: Hit<JobPostingSearchHit>,
  insights: WrappedInsightsClient,
  onclick: (event: MouseEvent) => void,
}

const JobPosting: React.FunctionComponent<Props> = (props) => {
  const { hit, insights } = props;
  const onClickEvent = (event: MouseEvent) => {
    try {
      event.preventDefault();
      event.stopImmediatePropagation();

      insights('clickedObjectIDsAfterSearch', { eventName: 'JobPosting Clicked' });
    } catch (e) {
      // eslint-disable-next-line no-console
      console.error(e);
    } finally {
      props.onclick(event);
    }
  };

  return (
    <a href={hit.link} onClick={onClickEvent}>
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
