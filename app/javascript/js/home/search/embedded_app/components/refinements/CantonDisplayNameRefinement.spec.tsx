import React from 'preact/compat';
import { deferredCheck, mountInstantSearchClient } from '../../../../../../../../jest/utils';
import CantonDisplayNameRefinement from './CantonDisplayNameRefinement';

describe('CantonDisplayNameRefinement', () => {
  const rendered = mountInstantSearchClient(<CantonDisplayNameRefinement />, 'CantonDisplayNameRefinement');

  it('renders correctly', () => deferredCheck(rendered, () => {
    expect(rendered).toMatchSnapshot();
  }));
});
