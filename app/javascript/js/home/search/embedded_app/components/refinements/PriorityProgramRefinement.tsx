import { ToggleRefinement } from 'react-instantsearch-dom';
import React from 'preact/compat';
import defaultTranslations from './defaultTranslations';

const PriorityProgramRefinement: React.FunctionComponent = () => (
  <ToggleRefinement
    attribute="priority_program"
    label={MyZivi.translations.search.refinements.priorityProgramLabel}
    limit={5}
    value={true}
    translations={defaultTranslations}
  />
);

export default PriorityProgramRefinement;
