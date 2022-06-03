import { shallow } from 'enzyme';
import React from 'preact/compat';
import App from '~/js/organizations/services/embedded_app/components/App';

describe('App', () => {
  it('matches Snapshot', () => {
    expect(shallow(<App />)).toMatchSnapshot();
  });
});
