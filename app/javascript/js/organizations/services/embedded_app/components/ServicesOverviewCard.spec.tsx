import { shallow } from 'enzyme';
import React from 'preact/compat';
import Rails from 'js/shared/__mocks__/Rails';
import Factories from 'js/tests/factories/Factories';
import ServiceFactory from 'js/tests/factories/ServiceFactory';
import { ServicesOverviewCardImpl } from './ServicesOverviewCard';
import { IApi } from 'js/shared/Api';
import { Service } from 'js/organizations/services/embedded_app/types';
import { ComponentChild, ComponentType } from 'preact';
import { ApiContext } from 'js/shared/ApiProvider';

function shallowUntil(componentInstance: any, TargetComponent: ComponentType<any>, { maxTries = 10 } = {}) {
  let root = shallow(componentInstance);

  if (typeof root.type() === 'string') {
    throw new Error('Cannot unwrap this component because it is not wrapped');
  }

  do {
    root = root.dive();
  } while (!root.is(TargetComponent) && --maxTries >= 0);

  return root.shallow();
}

const fakeApi: IApi = {
  fetchServices(): Promise<Array<Service>> {
    return Promise.resolve(Factories.buildList(ServiceFactory, 2));
  },
};

function fakeWrapInApiProvider(api: IApi) {
  return (wrapped: Element, component: ComponentType<any>) => {
    return shallowUntil(
      (
        <ApiContext.Provider value={api}>
          {wrapped}
        </ApiContext.Provider>
      ),
      component,
    );
  };
}

describe('ServicesOverviewCard', () => {
  const wrapper = fakeWrapInApiProvider(fakeApi)(<ServicesOverviewCardImpl />, ServicesOverviewCardImpl);

  beforeEach(() => {
    Rails.mockResponse(Factories.buildList(ServiceFactory, 2), MyZivi.paths.servicesOverview);
  });

  it('runs', (done) => {
    setImmediate(() => {
      expect(wrapper).toMatchSnapshot();
      done();
    });
  });
});
