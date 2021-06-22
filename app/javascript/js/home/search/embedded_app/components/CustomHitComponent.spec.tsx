import { mount } from 'enzyme';
import React from 'preact/compat';
import { InstantSearch } from 'react-instantsearch-dom';
import CustomHitComponent from './CustomHitComponent';
import { mockClient } from '../../../../tests/algolia/mocks';
import { deferredCheck } from '../../../../../../../jest/utils';

describe('CustomHitComponent', () => {
  let rendered;

  beforeEach(() => {
    rendered = mount(
      <InstantSearch searchClient={mockClient} indexName="JobPosting">
        <CustomHitComponent />
      </InstantSearch>,
    );
  });

  it('renders correctly', () => deferredCheck(rendered, () => {
    const hitsComponent = rendered.find('Hits');
    expect(hitsComponent).toMatchSnapshot();
  }));

  describe('when no results have been loaded yet', () => {
    it('renders no results page', () => {
      expect(rendered.find('Hits')).toMatchSnapshot();
    });
  });
});
