import { RefinementList } from 'react-instantsearch-dom';
import React from 'preact/compat';
import defaultTranslations from './defaultTranslations';

const CategoryDisplayNameRefinement: React.FunctionComponent = () => (
  <RefinementList
    attribute="category_display_name"
    searchable={false}
    limit={5}
    translations={defaultTranslations}
    showMore
  />
);

export default CategoryDisplayNameRefinement;
