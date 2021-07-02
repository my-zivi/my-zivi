import React from 'preact/compat';
import PoweredBy from './PoweredBy';
import { mountInstantSearchClient } from '../../../../../../../jest/utils';

describe('PoweredBy', () => {
  it('renders correctly', () => {
    const rendered = mountInstantSearchClient(<PoweredBy />, 'PoweredByImpl');
    expect(rendered).toMatchSnapshot();
  });
});
