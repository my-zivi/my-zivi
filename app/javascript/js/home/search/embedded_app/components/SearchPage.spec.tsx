import { shallow } from 'enzyme';
import React from 'preact/compat';
import SearchPage from './SearchPage';
import { mockClient } from '../../../../tests/algolia/mocks';

describe('SearchPage', () => {
  it('renders correctly', () => {
    expect(
      shallow(<SearchPage searchClient={mockClient} />).find('.search-main').first(),
    ).toMatchSnapshot();
  });
});
