import React from 'preact/compat';
import { deferredCheck, mountInstantSearchClient } from '../../../../../../../../jest/utils';
import LanguageRefinement from './LanguageRefinement';

describe('LanguageRefinement', () => {
  const rendered = mountInstantSearchClient(<LanguageRefinement />, 'LanguageRefinement');

  it('renders correctly', () => deferredCheck(rendered, () => {
    expect(rendered).toMatchSnapshot();
  }));
});
