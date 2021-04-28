import { shallow } from 'enzyme';
import CardHeader from 'js/organizations/services/embedded_app/components/CardHeader';
import React from 'preact/compat';

describe('CardHeader', () => {
  it('renders correctly', () => {
    const wrapper = shallow(<CardHeader overviewSubtitle={'This is my title'} />);
    expect(wrapper).toMatchSnapshot();
  });
});
