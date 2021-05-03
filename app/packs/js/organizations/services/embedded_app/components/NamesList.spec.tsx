import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';
import Factories from 'js/tests/factories/Factories';
import ServiceFactory from 'js/tests/factories/ServiceFactory';
import { shallow } from 'enzyme';
import NamesList from 'js/organizations/services/embedded_app/components/NamesList';
import React from 'preact/compat';

describe('NamesList', () => {
  const servicesList = new ServicesList(Factories.buildList(ServiceFactory, 3, {
    civilServant: {
      fullName: 'Peter Parker',
    },
  }));
  const wrapper = shallow(<NamesList servicesList={servicesList} />);

  it('renders three names for each service', () => {
    expect(wrapper.find('.name-row')).toHaveLength(servicesList.services.length);
  });

  it('renders the names of the civil servants', () => {
    expect(wrapper).toMatchSnapshot();
  });
});
