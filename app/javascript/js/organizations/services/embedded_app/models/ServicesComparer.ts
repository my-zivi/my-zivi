import moment from 'moment';
import { Service } from '~/js/organizations/services/embedded_app/types';

export default class ServicesComparer {
  static compare(service1: Service, service2: Service): number {
    if (service1.beginning === service2.beginning) {
      if ('localeCompare' in String.prototype) {
        return service1.civilServant.fullName.localeCompare(service2.civilServant.fullName);
      }

      return 0;
    }

    if (moment(service1.beginning).isBefore(service2.beginning)) {
      return -1;
    }

    return 1;
  }
}
