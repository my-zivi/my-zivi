import React from 'preact/compat';
import { deferredCheck, mountInstantSearchClient } from '../../../../../../../../jest/utils';
import MinimumServiceMonthsRefinement from './MinimumServiceMonthsRefinement';

describe('MinimumServiceMonthsRefinement', () => {
  const rendered = mountInstantSearchClient(<MinimumServiceMonthsRefinement />, 'MinimumServiceMonthsRefinement');

  it('renders correctly', () => deferredCheck(rendered, () => {
    expect(rendered).toMatchSnapshot();
  }));
});
