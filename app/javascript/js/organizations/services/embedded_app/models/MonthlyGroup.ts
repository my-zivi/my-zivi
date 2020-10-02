import { Moment } from 'moment';
import { DATE_FORMATS } from 'js/constants';

export default class MonthlyGroup {
  public readonly month: Moment;

  constructor(month: Moment) {
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

  mapDays<T>(callback: (day: Moment) => T): T[] {
    const daysSpan = this.monthEnd.diff(this.monthBeginning, 'days');

    const output: Array<T> = [];
    for (let delta = 0; delta <= daysSpan; delta += 1) {
      output.push(callback(this.monthBeginning.add(delta, 'days')));
    }

    return output;
  }
}
