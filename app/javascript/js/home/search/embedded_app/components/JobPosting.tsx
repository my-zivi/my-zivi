import React from 'preact/compat';
import { JobPostingSearchHit } from 'js/home/search/embedded_app/types';
import Ribbon from 'js/home/search/embedded_app/components/Ribbon';

const JobPostingIcon = React.memo((({ iconUrl, alt }) => (
  <img src={iconUrl} alt={alt} className="company-icon" />
)) as React.FunctionComponent<{ iconUrl: string, alt: string }>);

const JobPosting: React.FunctionComponent<{ hit: JobPostingSearchHit }> = ({ hit }) => (
  <a href={hit.link} target="_blank">
    <div className="card h-100 job-posting-card">
      <Ribbon hit={hit} />
      <div className="card-body">
        <div className="d-flex flex-column flex-md-row">
          <div className="mr-3">
            <JobPostingIcon iconUrl={hit.icon_url} alt={hit.organization_display_name} key={hit.icon_url} />
          </div>
          <div className="job-posting-card-content">
            <h5>{hit.title}</h5>
            <h6 className="text-muted">{hit.organization_display_name}</h6>
            <div className="job-description">{hit.brief_description}</div>
          </div>
        </div>
      </div>
    </div>
  </a>
);

export default JobPosting;
