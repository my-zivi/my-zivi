import { mount } from 'enzyme';
import * as React from 'preact/compat';
import SearchViewSwitch, { SearchView } from './SearchViewSwitch';

describe('SearchViewSwitch', () => {
  it('renders correctly', () => {
    expect(
      mount(<SearchViewSwitch activeView={SearchView.Map} onChange={jest.fn()} />).find('.search-view-switch'),
    ).toMatchSnapshot();
  });

  it('calls onChange when user clicks on a button', () => {
    const onChange = jest.fn();
    const wrapper = mount(<SearchViewSwitch activeView={SearchView.Map} onChange={onChange} />);
    wrapper.find('.search-view-switch-button').at(1).simulate('click');
    expect(onChange).toHaveBeenCalledWith(SearchView.Map);
  });

  it('renders the correct button as active', () => {
    const wrapper = mount(<SearchViewSwitch activeView={SearchView.Map} onChange={jest.fn()} />);
    expect(wrapper.find('.search-view-switch-button.active').text()).toEqual(
      globalThis.MyZivi.translations.search.searchView.map,
    );
  });
});
