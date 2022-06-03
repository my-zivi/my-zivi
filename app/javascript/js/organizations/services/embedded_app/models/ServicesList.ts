import moment, { Moment } from 'moment';
import { range } from 'lodash';
import MonthlyGroup from '~/js/organizations/services/embedded_app/models/MonthlyGroup';
import { Service } from '~/js/organizations/services/embedded_app/types';
import ServicesComparer from '~/js/organizations/services/embedded_app/models/ServicesComparer';

export default class ServicesList {
  public readonly services: Service[];
  public readonly earliestBeginning: Moment;
  public readonly latestEnding: Moment;
  private monthlyGroupsCache: MonthlyGroup[];

  constructor(services: Service[]) {
    this.services = ServicesList.sortServices(services);
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

  private static sortServices(services: Service[]): Service[] {
    return services.sort(ServicesComparer.compare);
  }

  private groupByMonth() {
    const monthsCount = Math.ceil(this.planEnding.diff(this.planBeginning, 'months', true));
    const months = range(monthsCount).map((offset) => this.planBeginning.add(offset, 'months').startOf('month'));

    return months.map((month) => new MonthlyGroup(month));
  }
}
