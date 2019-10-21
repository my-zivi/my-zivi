import { action, computed, observable } from 'mobx';
import moment from 'moment';
import { Holiday } from '../types';
import { DomainStore } from './domainStore';
import { MainStore } from './mainStore';

export class HolidayStore extends DomainStore<Holiday> {
  protected get entityName() {
    return {
      singular: 'Der Feiertag',
      plural: 'Die Feiertage',
    };
  }

  @computed
  get entities(): Holiday[] {
    return this.holidays;
  }

  set entities(entities: Holiday[]) {
    this.holidays = entities;
  }

  @computed
  get actualEntities(): Holiday[] {
    // Shows holidays which are today -> 1 Year
    const result = this.holidays.filter(
      holiday => moment(holiday.beginning) >= moment() && moment(holiday.beginning) <= moment().add(1, 'year'));
    return result.reverse();
  }

  @computed
  get futureEntities(): Holiday[] {
    // Shows holidays which are today -> 1 Year
    const result = this.holidays.filter(holiday => moment(holiday.beginning) >= moment());
    return result.reverse();
  }

  @computed
  get passedEntities(): Holiday[] {
    // Shows passed holidays
    const result = this.holidays.filter(holiday => moment(holiday.beginning) < moment());
    return result.reverse();
  }

  @computed
  get entity(): Holiday | undefined {
    return this.holiday;
  }

  set entity(holiday: Holiday | undefined) {
    this.holiday = holiday;
  }

  @observable
  holidays: Holiday[] = [];

  @observable
  holiday?: Holiday;

  protected entityURL = '/holidays/';
  protected entitiesURL = '/holidays/';

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  @action
  protected async doPost(holiday: Holiday) {
    const response = await this.mainStore.api.post<Holiday>('/holidays', holiday);
    this.holidays.unshift(response.data);
  }
}
