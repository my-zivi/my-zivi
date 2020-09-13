import { Service } from 'js/organizations/services/embedded_app/types';
import Rails from '@rails/ujs';

export default class Api {
  static async fetchData() {
    return new Promise((success: (services: Service[]) => void, error) => {
      Rails.ajax({
        url: '/organizations/services.json',
        type: 'GET',
        success,
        error,
      });
    });
  }
}
