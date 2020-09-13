import { Moment } from 'moment';
import { DATE_FORMATS } from 'js/constants';
import { Service } from 'js/organizations/services/embedded_app/types';

export default class MonthlyGroup {
  public readonly services: Service[];
  public readonly month: Moment;

  constructor(month: Moment, services: Service[]) {
    this.services = services;
    this.month = month;
  }

  get monthName() {
    return this.month.format(DATE_FORMATS.fullMonth);
  }
}
