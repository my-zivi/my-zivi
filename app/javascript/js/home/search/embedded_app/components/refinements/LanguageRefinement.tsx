import { RefinementList } from 'react-instantsearch-dom';
import React from 'preact/compat';
import defaultTranslations from './defaultTranslations';

const LanguageRefinement: React.FunctionComponent = () => (
  <RefinementList
    attribute="language"
    searchable={false}
    limit={5}
    translations={defaultTranslations}
    transformItems={
      (items) => items.map((item) => (
        { ...item, label: MyZivi.translations.search.refinements.languages[item.label] }
      ))
    }
    showMore
  />
);

export default LanguageRefinement;
