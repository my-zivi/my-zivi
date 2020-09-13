import moment, { Moment } from 'moment';
import { range } from 'lodash';
import MonthlyGroup from 'js/organizations/services/embedded_app/models/MonthlyGroup';
import { Service } from 'js/organizations/services/embedded_app/types';

export default class ServicesList {
  public readonly services: Service[];
  public readonly earliestBeginning: Moment;
  public readonly latestEnding: Moment;
  private _monthlyGroups: MonthlyGroup[];

  constructor(services) {
    this.services = services;
    this.earliestBeginning = moment.min(this.services.map(service => moment(service['beginning'])));
    this.latestEnding = moment.max(this.services.map(service => moment(service['ending'])));
  }

  get planBeginning() {
    return moment(this.earliestBeginning).startOf('month');
  }

  get planEnding() {
    return moment(this.latestEnding).endOf('month');
  }

  get monthlyGroups() {
    if (this._monthlyGroups) {
      return this._monthlyGroups;
    }

    this._monthlyGroups = this.groupByMonth();
    return this._monthlyGroups;
  }

  daysSpan() {
    return this.planEnding.diff(this.planBeginning, 'days');
  }

  mapDays(callback: (day: Moment) => void) {
    let output = [];
    for (let delta = 0; delta <= this.daysSpan(); ++delta) {
      output.push(callback(this.planBeginning.add(delta, 'days')));
    }

    return output;
  }

  private groupByMonth() {
    const monthsCount = Math.ceil(this.planEnding.diff(this.planBeginning, 'months', true));
    const months = range(monthsCount).map(offset => {
      return this.planBeginning.add(offset, 'months').startOf('month');
    });

    return months.map(month => {
      return new MonthlyGroup(month,
        this.services.filter(service => {
          return moment(service.beginning).isSameOrBefore(month, 'month') || moment(service.ending).isSameOrAfter(month, 'month');
        }),
      );
    });
  }
}
