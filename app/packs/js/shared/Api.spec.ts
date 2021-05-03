import Rails from '@rails/ujs';
import Api from './Api';
import ServiceFactory from '../tests/factories/ServiceFactory';

describe('Api', () => {
  const api = new Api();

  beforeEach(() => Rails.mockError(null));

  describe('fetchServices', () => {
    it('calls the correct endpoint', async () => {
      const response = [ServiceFactory.build()];
      Rails.mockResponse(response, MyZivi.paths.servicesOverview);

      await expect(api.fetchServices()).resolves.toEqual(response);
    });

    it('rejects if an error occurs', async () => {
      const error = new Error('oups');
      Rails.mockError(error);

      expect.assertions(1);
      await expect(api.fetchServices()).rejects.toEqual(error);
    });
  });
});
