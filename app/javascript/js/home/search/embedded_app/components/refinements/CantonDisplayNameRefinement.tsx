import { RefinementList } from 'react-instantsearch-dom';
import React from 'preact/compat';
import { flatten, orderBy, partition } from 'lodash';
import defaultTranslations from './defaultTranslations';

const transformItems = (items) => (
  flatten(
    partition(items, ['isRefined', true]).map((partitioned) => orderBy(partitioned, ['label', 'asc'])),
  )
);

const CantonDisplayNameRefinement: React.FunctionComponent = () => (
  <RefinementList
    attribute="canton_display_name"
    searchable={true}
    limit={5}
    showMore={true}
    transformItems={
      transformItems
    }
    translations={defaultTranslations}
  />
);

export default CantonDisplayNameRefinement;
