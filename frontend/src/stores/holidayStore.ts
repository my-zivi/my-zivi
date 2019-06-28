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

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  @action
  protected async doDelete(id: number) {
    await this.mainStore.api.delete('/holidays/' + id);
    await this.doFetchAll();
  }

  @action
  protected async doFetchAll() {
    const res = await this.mainStore.api.get<Holiday[]>('/holidays');
    this.holidays = res.data;
  }

  @action
  protected async doPost(holiday: Holiday) {
    const response = await this.mainStore.api.post<Holiday>('/holidays', holiday);
    this.holidays.unshift(response.data);
  }

  @action
  protected async doPut(holiday: Holiday) {
    const response = await this.mainStore.api.put<Holiday[]>('/holidays/' + holiday.id, holiday);
    this.holidays = response.data;
  }
}
