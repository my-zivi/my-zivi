import TableHeader from 'js/organizations/services/embedded_app/components/TableHeader';
import MonthlyGroup from 'js/organizations/services/embedded_app/models/MonthlyGroup';
import { shallow } from 'enzyme';
import moment from 'moment';
import React from 'preact/compat';

describe('TableHeader', () => {
  it('renders correctly', () => {
    const monthlyGroup = new MonthlyGroup(moment('2020-01-01'));
    const wrapper = shallow(<TableHeader monthlyGroup={monthlyGroup} />);
    expect(wrapper).toMatchSnapshot();
  });
});
