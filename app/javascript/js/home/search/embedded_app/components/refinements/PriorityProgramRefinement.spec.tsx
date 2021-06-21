import React from 'preact/compat';
import { deferredCheck, mountInstantSearchClient } from '../../../../../../../../jest/utils';
import PriorityProgramRefinement from './PriorityProgramRefinement';

describe('PriorityProgramRefinement', () => {
  const rendered = mountInstantSearchClient(<PriorityProgramRefinement />, 'PriorityProgramRefinement');

  it('renders correctly', () => deferredCheck(rendered, () => {
    expect(rendered).toMatchSnapshot();
  }));
});
