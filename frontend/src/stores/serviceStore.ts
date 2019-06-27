import { action, computed, observable } from 'mobx';
import { Service, ServiceCollection } from '../types';
import { DomainStore } from './domainStore';
import { MainStore } from './mainStore';

export class ServiceStore extends DomainStore<Service, ServiceCollection> {
  protected get entityName() {
    return {
      singular: 'Der Zivildiensteinsatz',
      plural: 'Die Zivildiensteinsätze',
    };
  }

  @computed
  get entities(): ServiceCollection[] {
    return this.services;
  }

  @computed
  get entity(): Service | undefined {
    return this.service;
  }

  set entity(service: Service | undefined) {
    this.service = service;
  }

  @observable
  services: ServiceCollection[] = [];

  @observable
  service?: Service;

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  @action
  async fetchByYear(year: string) {
    const res = await this.mainStore.api.get<ServiceCollection[]>('/services/?year=' + year);
    this.services = res.data;
  }

  async calcEligibleDays(start: string, end: string) {
    const response = await this.mainStore.api.get<EligibleDays>('/service_days/eligible_days?beginning=' + start + '&ending=' + end);
    return response.data;
  }

  async calcPossibleEndDate(start: string, days: number) {
    const response = await this.mainStore.api.get<PossibleEndDate>('/service_days/possible_end_date?beginning=' + start + '&days=' + days);
    return response.data;
  }

  @action
  async doPutDraft(id: number) {
    // TODO: Adapt to normal PUT
    const response = await this.mainStore.api.get<Service>('/services/' + id + '/draft');
    return response.data;
  }

  @action
  protected async doDelete(id: number) {
    await this.mainStore.api.delete('/services/' + id);
    await this.doFetchAll();
  }

  @action
  protected async doFetchAll() {
    const res = await this.mainStore.api.get<ServiceCollection[]>('/services');
    this.services = res.data;
  }

  // @action
  // public async doFetchOne(id: number) {
  //   const response = await this.mainStore.api.get<Service>('/services/' + id);
  //   this.service = response.data;
  // }

  @action
  protected async doPost(service: Service) {
    const response = await this.mainStore.api.post<ServiceCollection[]>('/services', service);
    this.services = response.data;
  }

  @action
  protected async doPut(service: Service) {
    const response = await this.mainStore.api.put<ServiceCollection[]>('/services/' + service.id, service);
    this.services = response.data;
  }
}

interface EligibleDays {
  data: string;
}

interface PossibleEndDate {
  data: string;
}
