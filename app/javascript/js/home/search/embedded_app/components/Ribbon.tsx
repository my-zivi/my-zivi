/* eslint-disable camelcase */
import { Relevancy, JobPostingSearchHit } from 'js/home/search/embedded_app/types';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import React from 'preact/compat';

const Ribbon: React.FunctionComponent<{hit: JobPostingSearchHit}> = ({ hit: { relevancy, featured_as_new } }) => {
  if (relevancy === Relevancy.Urgent) {
    return (
      <div className="featured-ribbon red">
        <FontAwesomeIcon icon={['fas', 'exclamation']} className="mr-2" />
        {MyZivi.translations.search.ribbons.urgent}
      </div>
    );
  }

  if (relevancy === Relevancy.Featured) {
    return (
      <div className="featured-ribbon yellow">
        <FontAwesomeIcon icon={['fas', 'star']} className={'mr-1'} />
        {MyZivi.translations.search.ribbons.featured}
      </div>
    );
  }

  if (featured_as_new) {
    return <div className="featured-ribbon blue">{MyZivi.translations.search.ribbons.new}</div>;
  }

  return <></>;
};

export default Ribbon;
