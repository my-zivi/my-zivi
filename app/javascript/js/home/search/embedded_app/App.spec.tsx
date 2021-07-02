import { shallow } from 'enzyme';
import React from 'preact/compat';
import App from './App';

describe('App', () => {
  it('renders search page', () => {
    expect(
      shallow(<App />).find('SearchPage'),
    ).not.toBeUndefined();
  });
});
