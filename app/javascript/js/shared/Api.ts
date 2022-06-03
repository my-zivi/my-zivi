import Rails from '@rails/ujs';
import { Service } from '~/js/organizations/services/embedded_app/types';

interface RequestOptions {
  url: string;
  type: 'GET' | 'POST';

  [name: string]: unknown;
}

export interface IApi {
  fetchServices(): Promise<Array<Service>>;
}

export default class Api implements IApi {
  async fetchServices(): Promise<Array<Service>> {
    return this.request<Array<Service>>({
      url: MyZivi.paths.servicesOverview,
      type: 'GET',
    });
  }

  // eslint-disable-next-line class-methods-use-this
  private request<T>(options: RequestOptions): Promise<T> {
    return new Promise((success: (response: T) => void, error: (cause: unknown) => void) => {
      Rails.ajax({ ...options, success, error });
    });
  }
}
