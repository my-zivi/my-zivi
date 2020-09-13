import moment, { Moment } from 'moment';
import { range } from 'lodash';
import MonthlyGroup from 'js/organizations/services/embedded_app/models/MonthlyGroup';
import { Service } from 'js/organizations/services/embedded_app/types';

export default class ServicesList {
  public readonly services: Service[];
  public readonly earliestBeginning: Moment;
  public readonly latestEnding: Moment;
  private monthlyGroupsCache: MonthlyGroup[];

  constructor(services: Service[]) {
    this.services = services;
    this.earliestBeginning = moment.min(this.services.map((service) => moment(service.beginning)));
    this.latestEnding = moment.max(this.services.map((service) => moment(service.ending)));
  }

  get planBeginning(): Moment {
    return moment(this.earliestBeginning).startOf('month');
  }

  get planEnding(): Moment {
    return moment(this.latestEnding).endOf('month');
  }

  get monthlyGroups(): MonthlyGroup[] {
    if (this.monthlyGroupsCache) {
      return this.monthlyGroupsCache;
    }

    this.monthlyGroupsCache = this.groupByMonth();
    return this.monthlyGroupsCache;
  }

  daysSpan(): number {
    return this.planEnding.diff(this.planBeginning, 'days');
  }

  mapDays<T>(callback: (day: Moment) => T): T[] {
    const output: Array<T> = [];
    for (let delta = 0; delta <= this.daysSpan(); delta += 1) {
      output.push(callback(this.planBeginning.add(delta, 'days')));
    }

    return output;
  }

  private groupByMonth() {
    const monthsCount = Math.ceil(this.planEnding.diff(this.planBeginning, 'months', true));
    const months = range(monthsCount).map((offset) => this.planBeginning.add(offset, 'months').startOf('month'));

    return months.map((month) => {
      const predicate = (service) => {
        const beginsInMonth = moment(service.beginning).isSameOrBefore(month, 'month');
        const endsInMonth = moment(service.ending).isSameOrAfter(month, 'month');

        return beginsInMonth || endsInMonth;
      };

      return new MonthlyGroup(month, this.services.filter(predicate));
    });
  }
}
