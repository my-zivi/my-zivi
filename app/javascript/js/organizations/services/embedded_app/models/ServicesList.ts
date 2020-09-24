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
    this.services = this.sortServices(services);
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

  private sortServices(services: Service[]): Service[] {
    return services.sort((service1, service2) => {
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
    });
  }
}
