import { connectPoweredBy } from 'react-instantsearch-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { FunctionComponent } from 'preact';
import React from 'preact/compat';

const PoweredByImpl: FunctionComponent<{ url: string }> = ({ url }) => (
  <a href={url} className="text-muted" target="_blank" rel="nofollow noopener noreferrer">
    {MyZivi.translations.search.poweredBy}
    <FontAwesomeIcon icon={['fab', 'algolia']} className={'mx-1'} />
    Algolia
  </a>
);

export default connectPoweredBy(PoweredByImpl);
