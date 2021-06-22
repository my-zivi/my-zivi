import React from 'preact/compat';
import { shallow } from 'enzyme';
import RefinementsPanel from './RefinementsPanel';

describe('RefinementsPanel', () => {
  it('renders correctly', () => {
    expect(
      shallow(<RefinementsPanel />),
    ).toMatchSnapshot();
  });
});
