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
    return this.month.format(DATE_FORMATS.fullMonth);
  }

  mapDays<T>(callback: (day: Moment) => T): T[] {
    const monthStart = this.month.startOf('month');
    const daysSpan = this.month.endOf('month').diff(monthStart, 'days');
    console.log(daysSpan);

    const output: Array<T> = [];
    for (let delta = 0; delta <= daysSpan; delta += 1) {
      output.push(callback(monthStart.add(delta, 'days')));
    }

    return output;
  }
}
