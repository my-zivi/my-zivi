import { Service } from 'js/organizations/services/embedded_app/types';
import Rails from '@rails/ujs';

interface RequestOptions {
  url: string;
  type: 'GET' | 'POST';

  [name: string]: unknown;
}

export default class Api {
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
