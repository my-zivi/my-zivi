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
    const response = await this.mainStore.api.post<ServiceSpecification>(this.entitiesURL, serviceSpecification);
    this.serviceSpecifications.unshift(response.data);
  }
}
