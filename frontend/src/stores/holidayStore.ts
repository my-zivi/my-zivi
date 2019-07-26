import { action, computed, observable } from 'mobx';
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
