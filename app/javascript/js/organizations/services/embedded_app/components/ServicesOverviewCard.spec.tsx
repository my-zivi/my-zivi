import { shallow } from 'enzyme';
import React from 'preact/compat';
import Rails from 'js/shared/__mocks__/Rails';
import Factories from 'js/tests/factories/Factories';
import ServiceFactory from 'js/tests/factories/ServiceFactory';
import ServicesOverviewCard from './ServicesOverviewCard';

describe('ServicesOverviewCard', () => {
  it('runs', () => {
    Rails.mockResponse(Factories.buildList(ServiceFactory, 2), MyZivi.paths.servicesOverview);
    const wrapper = shallow(<ServicesOverviewCard />);
    wrapper.update();

    expect(wrapper).toMatchSnapshot();
  });
});
