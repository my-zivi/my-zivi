import moment from 'moment';

export default class ServicesPlan {
  constructor(services) {
    this.services = services;
  }

  get earliestBeginning() {
    return moment.min(this.services.map(service => service['beginning']));
  }

  get latestEnding() {
    return moment.max(this.services.map(service => service['ending']));
  }

  get planBeginning() {
    return moment(this.earliestBeginning).startOf('month');
  }

  get planEnding() {
    return moment(this.latestEnding).endOf('month');
  }

  get daysSpan() {
    return this.latestEnding.diff(this.earliestBeginning, 'days');
  }
}
