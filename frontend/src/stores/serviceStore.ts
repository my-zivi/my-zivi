import { action, computed, observable } from 'mobx';
import moment from 'moment';
import { Service, ServiceCollection } from '../types';
import { apiDateFormat } from './apiStore';
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

  set entities(entities: ServiceCollection[]) {
    this.services = entities;
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

  protected entitiesURL = '/services/';
  protected entityURL = '/services/';

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  @action
  async fetchByYear(year: string) {
    const res = await this.mainStore.api.get<ServiceCollection[]>('/services/?year=' + year);
    this.services = res.data;
  }

  async calcServiceDaysOrEnding(values: {beginning: string, ending?: string, service_days?: number}) {
    values.beginning = moment(values.beginning).format(apiDateFormat);
    if (values.ending !== undefined) {
      values.ending = moment(values.ending).format(apiDateFormat);
      return this.callServiceCalculator<EligibleDays>(
        `/services/calculate_service_days?beginning=${values.beginning}&ending=${values.ending}`,
      );
    } else if (values.service_days !== undefined) {
      return this.callServiceCalculator<PossibleEndDate>(
        `/services/calculate_ending?beginning=${values.beginning}&service_days=${values.service_days}`,
      );
    }
    return false;
  }

  @action
  async doConfirmPut(id: number) {
    const response = await this.mainStore.api.put<Service>('/services/' + id + '/confirm');
    this.service = response.data;
  }

  @action
  protected async doPost(service: Service) {
    // Todo: Implement
    const response = await this.mainStore.api.post<ServiceCollection[]>('/services', { service });
    this.services = response.data;
  }

  @action
  protected async doPut(service: Service) {
    // Todo: Implement
    const response = await this.mainStore.api.put<ServiceCollection[]>('/services/' + service.id, service);
    this.services = response.data;
  }

  private async callServiceCalculator<ReturnType>(url: string) {
    const response = await this.mainStore.api.get<ReturnType>(url);
    return response.data;
  }
}

interface EligibleDays {
  result: number;
}

interface PossibleEndDate {
  result: string;
}
