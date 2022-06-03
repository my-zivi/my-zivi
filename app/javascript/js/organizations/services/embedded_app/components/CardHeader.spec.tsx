import { shallow } from 'enzyme';
import React from 'preact/compat';
import CardHeader from '~/js/organizations/services/embedded_app/components/CardHeader';

describe('CardHeader', () => {
  it('renders correctly', () => {
    const wrapper = shallow(<CardHeader overviewSubtitle={'This is my title'} />);
    expect(wrapper).toMatchSnapshot();
  });
});
