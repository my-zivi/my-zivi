import React from 'preact/compat';
import { JobPostingSearchHit } from 'js/home/search/embedded_app/types';
import Ribbon from 'js/home/search/embedded_app/components/Ribbon';

const JobPostingIcon = React.memo((({ iconUrl, alt }) => (
  <img src={iconUrl} alt={alt} className="job-posting-icon" />
)) as React.FunctionComponent<{ iconUrl: string, alt: string }>);

const JobPosting: React.FunctionComponent<{ hit: JobPostingSearchHit }> = ({ hit }) => (
  <a href={hit.link}>
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

export default JobPosting;
