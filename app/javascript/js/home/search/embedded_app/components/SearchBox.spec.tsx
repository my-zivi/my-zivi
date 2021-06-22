import { shallow } from 'enzyme';
import React from 'preact/compat';
import SearchBox, { SearchBoxRef } from './SearchBox';

const noop = () => null;

describe('SearchBox', () => {
  it('renders correctly', () => {
    expect(
      shallow(<SearchBox currentRefinement="" refine={noop} onBlur={noop} onFocus={noop} />),
    ).toMatchSnapshot();
  });

  it('accepts imperative handle', () => {
    const ref = React.createRef<SearchBoxRef>();
    const refine = jest.fn();
    const rendered = shallow(<SearchBox ref={ref} currentRefinement="" refine={refine} onBlur={noop} onFocus={noop} />);
    ref.current.autocompleteSearch('my-search');
    expect(refine).toHaveBeenCalledWith('my-search');

    expect(rendered.update().find('.search-field input').props()).toHaveProperty('value', 'my-search');
  });
});
