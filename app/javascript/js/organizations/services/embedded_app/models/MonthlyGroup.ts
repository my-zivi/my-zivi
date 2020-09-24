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

  get monthName(): string {
    return this.monthBeginning.format(DATE_FORMATS.fullMonth);
  }

  get monthBeginning(): Moment {
    return Object.freeze(this.month.clone().startOf('month'));
  }

  get monthEnd(): Moment {
    return Object.freeze(this.month.clone().endOf('month'));
  }

  containsService(service: Service): boolean {
    return this.services.includes(service);
  }

  mapDays<T>(callback: (day: Moment) => T): T[] {
    const daysSpan = this.monthEnd.diff(this.monthBeginning, 'days');

    const output: Array<T> = [];
    for (let delta = 0; delta <= daysSpan; delta += 1) {
      output.push(callback(this.monthBeginning.add(delta, 'days')));
    }

    return output;
  }
}
