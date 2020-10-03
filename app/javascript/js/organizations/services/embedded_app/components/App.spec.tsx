import App from 'js/organizations/services/embedded_app/components/App';
import { shallow } from 'enzyme';
import React from 'preact/compat';
import Rails from 'js/shared/__mocks__/Rails';
import Factories from 'js/tests/factories/Factories';
import ServiceFactory from 'js/tests/factories/ServiceFactory';

describe('App', () => {
  it('runs', () => {
    Rails.mockResponse(Factories.buildList(ServiceFactory, 2), MyZivi.paths.servicesOverview);
    const wrapper = shallow(<App />);
    wrapper.update();

    expect(wrapper).toMatchSnapshot();
  });
});
