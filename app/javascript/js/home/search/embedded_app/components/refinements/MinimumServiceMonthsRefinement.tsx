import { RefinementList } from 'react-instantsearch-dom';
import React from 'preact/compat';
import { orderBy } from 'lodash';
import defaultTranslations from './defaultTranslations';

const MinimumServiceMonthsRefinement: React.FunctionComponent = () => (
  <RefinementList
    attribute="minimum_service_months"
    searchable={false}
    limit={5}
    translations={defaultTranslations}
    showMore
    transformItems={
      (items) => orderBy(items, 'label', 'asc').map((item) => ({ ...item, label: `${item.label} Monat(e)` }))
    }
  />
);

export default MinimumServiceMonthsRefinement;
