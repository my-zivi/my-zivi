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

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  @action
  protected async doDelete(id: number) {
    await this.mainStore.api.delete('/service_specifications/' + id);
    await this.doFetchAll();
  }

  @action
  protected async doFetchAll() {
    const response = await this.mainStore.api.get<ServiceSpecification[]>('/service_specifications');
    this.serviceSpecifications = response.data;
  }

  @action
  protected async doPost(serviceSpecification: ServiceSpecification) {
    const response = await this.mainStore.api.post<ServiceSpecification[]>('/service_specifications', serviceSpecification);
    this.serviceSpecifications = response.data;
  }

  @action
  protected async doPut(serviceSpecification: ServiceSpecification) {
    const url = `/service_specifications/${serviceSpecification.id}`;
    const response = await this.mainStore.api.put<ServiceSpecification[]>(url, serviceSpecification);
    this.serviceSpecifications = response.data;
  }
}
