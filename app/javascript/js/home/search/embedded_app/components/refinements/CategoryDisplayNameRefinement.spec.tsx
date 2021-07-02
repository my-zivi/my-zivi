import React from 'preact/compat';
import { deferredCheck, mountInstantSearchClient } from '../../../../../../../../jest/utils';
import CategoryDisplayNameRefinement from './CategoryDisplayNameRefinement';

describe('CategoryDisplayNameRefinement', () => {
  const rendered = mountInstantSearchClient(<CategoryDisplayNameRefinement />, 'CategoryDisplayNameRefinement');

  it('renders correctly', () => deferredCheck(rendered, () => {
    expect(rendered).toMatchSnapshot();
  }));
});
