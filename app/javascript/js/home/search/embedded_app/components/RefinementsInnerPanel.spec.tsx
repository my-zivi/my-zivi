import React from 'preact/compat';
import { shallow } from 'enzyme';
import RefinementsInnerPanel from './RefinementsInnerPanel';

describe('RefinementsInnerPanel', () => {
  it('renders correctly', () => {
    expect(
      shallow(<RefinementsInnerPanel />),
    ).toMatchSnapshot();
  });
});
