import { shallow, mount } from 'enzyme';
import React from 'preact/compat';
import SearchPage from './SearchPage';
import { mockClient } from '../../../../tests/algolia/mocks';
import TilesSearchView from './TilesSearchView';
import MapSearchView from './MapSearchView';

describe('SearchPage', () => {
  it('renders correctly', () => {
    expect(
      shallow(<SearchPage searchClient={mockClient} />).find('.search-main').first(),
    ).toMatchSnapshot();
  });

  it('renders tiles view by default', () => {
    const page = shallow(<SearchPage searchClient={mockClient} />);
    expect(page.find(TilesSearchView).exists()).toBe(true);
  });

  it('renders map view when user clicks on Map view button', () => {
    const page = mount(<SearchPage searchClient={mockClient} />);
    expect(page.find(TilesSearchView).exists()).toBe(true);
    page.findWhere((node) => (
      node.type() === 'button' && node.text() === globalThis.MyZivi.translations.search.searchView.map
    )).simulate('click');
    expect(page.find(TilesSearchView).exists()).toBe(false);
    expect(page.find(MapSearchView).exists()).toBe(true);
  });
});
