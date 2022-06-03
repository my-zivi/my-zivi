import Factories from '~/js/tests/factories/Factories';
import ServiceFactory from '~/js/tests/factories/ServiceFactory';
import { shallow } from 'enzyme';
import OverviewTable from '~/js/organizations/services/embedded_app/components/OverviewTable';
import React from 'preact/compat';
import ServicesList from '~/js/organizations/services/embedded_app/models/ServicesList';

describe('OverviewTable', () => {
  const servicesList = new ServicesList(Factories.buildList(ServiceFactory, 2, {
    civilServant: {
      fullName: 'Phipsi Fame',
    },
  }));
  const wrapper = shallow(<OverviewTable servicesList={servicesList} />);

  it('renders correctly', () => {
    expect(wrapper).toMatchSnapshot();
  });
});
