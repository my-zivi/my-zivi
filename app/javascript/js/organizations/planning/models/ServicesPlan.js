import moment from 'moment';

export default class ServicesPlan {
  constructor(services) {
    this.services = services;
  }

  get earliestBeginning() {
    return moment(moment.min(this.services.map(service => service['beginning'])));
  }

  get latestEnding() {
    return moment(moment.max(this.services.map(service => service['ending'])));
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

  mapDays(callback) {
    let output = [];
    for (let delta = 0; delta <= this.daysSpan(); ++delta) {
      output.push(callback(this.planBeginning.add(delta, 'days')));
    }

    return output;
  }
}
