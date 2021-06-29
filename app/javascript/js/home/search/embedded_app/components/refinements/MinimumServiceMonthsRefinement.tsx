import { RefinementList } from 'react-instantsearch-dom';
import React from 'preact/compat';
import { orderBy } from 'lodash';
import defaultTranslations from './defaultTranslations';

const transformItems = (items) => {
  return orderBy(items, 'label', 'asc')
    .map((item) => {
      const { one, other } = MyZivi.translations.search.refinements.month;
      const translation = item.label === '1' ? one : other;
      return ({ ...item, label: `${item.label} ${translation}` });
    });
};

const MinimumServiceMonthsRefinement: React.FunctionComponent = () => (
  <RefinementList
    attribute="minimum_service_months"
    searchable={false}
    limit={5}
    translations={defaultTranslations}
    showMore
    transformItems={transformItems}
  />
);

export default MinimumServiceMonthsRefinement;
