import { action, computed, observable } from 'mobx';
import { ServiceSpecification } from '../types';
import { DomainStore } from './domainStore';
import { MainStore } from './mainStore';

export class ServiceSpecificationStore extends DomainStore<ServiceSpecification> {
  protected get entityName() {
    return {
      singular: 'Das Pflichtenheft',
      plural: 'Die Pflichtenhefte',
    };
  }

  @computed
  get entities(): ServiceSpecification[] {
    return this.serviceSpecifications;
  }

  set entities(entities: ServiceSpecification[]) {
    this.serviceSpecifications = entities;
  }

  @computed
  get entity(): ServiceSpecification | undefined {
    return this.serviceSpecification;
  }

  set entity(holiday: ServiceSpecification | undefined) {
    this.serviceSpecification = holiday;
  }

  @observable
  serviceSpecifications: ServiceSpecification[] = [];

  @observable
  serviceSpecification?: ServiceSpecification;

  protected entitiesURL = '/service_specifications/';
  protected entityURL = '/service_specifications/';

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  @action
  protected async doPost(serviceSpecification: ServiceSpecification) {
    const data = { service_specification: serviceSpecification };
    const response = await this.mainStore.api.post<ServiceSpecification[]>('/service_specifications', data);
    this.serviceSpecifications = response.data;
  }

  @action
  protected async doPut(serviceSpecification: ServiceSpecification) {
    const url = `/service_specifications/${serviceSpecification.identification_number}`;
    const response = await this.mainStore.api.put<ServiceSpecification[]>(url, serviceSpecification);
    this.serviceSpecifications = response.data;
  }
}
