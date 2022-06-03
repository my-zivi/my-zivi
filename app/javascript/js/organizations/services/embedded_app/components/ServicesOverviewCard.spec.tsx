import React from 'preact/compat';
import Factories from '~/js/tests/factories/Factories';
import ServiceFactory from '~/js/tests/factories/ServiceFactory';
import { IApi } from '~/js/shared/Api';
import { Service } from '~/js/organizations/services/embedded_app/types';
import ServicesOverviewCard from './ServicesOverviewCard';
import { fakeWrapInApiProvider, setImmediate } from '../../../../../../../jest/utils';

const servicesOverviewWrapper = (fakeApi: IApi) => (
  fakeWrapInApiProvider(fakeApi)(<ServicesOverviewCard />, 'ServicesOverviewCardImpl')
);

describe('ServicesOverviewCard', () => {
  describe('when api returns services', () => {
    const wrapper = servicesOverviewWrapper({
      fetchServices(): Promise<Array<Service>> {
        return Promise.resolve(Factories.buildList(ServiceFactory, 2, {
          civilServant: {
            fullName: 'Peter Parker',
          },
        }));
      },
    });

    it('matches snapshot', (done) => {
      setImmediate(() => {
        expect(wrapper.update()).toMatchSnapshot();
        done();
      });
    });
  });

  describe('when API is still loading', () => {
    const wrapper = servicesOverviewWrapper({
      fetchServices(): Promise<Array<Service>> {
        return new Promise(jest.fn());
      },
    });

    it('displays a loading indicator', (done) => {
      setImmediate(() => {
        expect(wrapper.update()).toMatchSnapshot();
        done();
      });
    });
  });

  describe('when API returns an error', () => {
    const wrapper = servicesOverviewWrapper({
      fetchServices(): Promise<Array<Service>> {
        // eslint-disable-next-line prefer-promise-reject-errors
        return Promise.reject({ status: 404, error: 'Not Found' });
      },
    });

    it('displays the error', (done) => {
      setImmediate(() => {
        expect(wrapper.update()).toMatchSnapshot();
        done();
      });
    });
  });
});
