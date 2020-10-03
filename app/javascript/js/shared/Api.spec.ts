import Rails from '@rails/ujs';
import Api from './Api';
import ServiceFactory from '../tests/factories/ServiceFactory';

describe('Api', () => {
  beforeEach(() => Rails.mockError(null));

  describe('fetchServices', () => {
    it('calls the correct endpoint', async () => {
      const response = [ServiceFactory.build()];
      Rails.mockResponse(response, MyZivi.paths.servicesOverview);

      expect(await Api.fetchServices()).toEqual(response);
    });

    it('rejects if an error occurs', async () => {
      const error = new Error('oups');
      Rails.mockError(error);

      expect.assertions(1);
      await expect(Api.fetchServices()).rejects.toEqual(error);
    });
  });
});
