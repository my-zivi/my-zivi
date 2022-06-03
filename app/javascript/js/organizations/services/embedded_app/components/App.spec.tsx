import { shallow } from 'enzyme';
import App from '~/js/organizations/services/embedded_app/components/App';
import React from 'preact/compat';

describe('App', () => {
  it('matches Snapshot', () => {
    expect(shallow(<App />)).toMatchSnapshot();
  });
});
