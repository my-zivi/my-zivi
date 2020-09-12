import moment, { Moment } from 'moment';

export interface Service {
  beginning: string;
  ending: string;
  civilServant: {
    fullName: string;
  };
}

export default class ServicesPlan {
  private readonly services: Service[];

  constructor(services) {
    this.services = services;
  }

  get earliestBeginning() {
    return moment.min(this.services.map(service => moment(service['beginning'])));
  }

  get latestEnding() {
    return moment.max(this.services.map(service => moment(service['ending'])));
  }

  get planBeginning() {
    return moment(this.earliestBeginning).startOf('month');
  }

  get planEnding() {
    return moment(this.latestEnding).endOf('month');
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
}
