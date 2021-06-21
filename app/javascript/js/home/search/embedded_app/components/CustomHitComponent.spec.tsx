import { mount } from 'enzyme';
import React from 'preact/compat';
import { InstantSearch } from 'react-instantsearch-dom';
import { defer } from 'lodash';
import CustomHitComponent from './CustomHitComponent';
import { mockClient } from '../../../../tests/algolia/mocks';

describe('CustomHitComponent', () => {
  it('renders correctly', () => {
    const rendered = mount(
      <InstantSearch searchClient={mockClient} indexName="JobPosting">
        <CustomHitComponent />
      </InstantSearch>,
    );

    return new Promise((resolve) => {
      defer(() => {
        rendered.update();
        const hitsComponent = rendered.find('Hits');
        expect(hitsComponent).toMatchSnapshot();
        resolve(undefined);
      });
    });
  });

  describe('when no results have been loaded yet', () => {
    it('renders no results page', () => {
      const rendered = mount(
        <InstantSearch searchClient={mockClient} indexName="JobPosting">
          <CustomHitComponent />
        </InstantSearch>,
      );

      expect(rendered.find('Hits')).toMatchSnapshot();
    });
  });
});
