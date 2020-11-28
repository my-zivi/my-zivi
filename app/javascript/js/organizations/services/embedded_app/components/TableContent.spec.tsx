import { shallow } from 'enzyme';
import moment from 'moment';
import React from 'preact/compat';
import ServicesList from '../models/ServicesList';
import Factories from '../../../../tests/factories/Factories';
import ServiceFactory from '../../../../tests/factories/ServiceFactory';
import MonthlyGroup from '../models/MonthlyGroup';
import TableContent from './TableContent';

describe('TableContent', () => {
  const servicesList = new ServicesList([
    ...Factories.buildList(ServiceFactory, 2),
    ServiceFactory.build({
      definitive: false,
      beginning: '2020-02-03',
      ending: '2020-03-06',
    }),
  ]);
  const monthlyGroup = new MonthlyGroup(moment(servicesList.services[0].beginning));
  const wrapper = shallow(<TableContent servicesList={servicesList} currentMonthlyGroup={monthlyGroup} />);

  it('renders correctly', () => {
    expect(wrapper).toMatchSnapshot();
  });
});
