import { action, computed, observable } from 'mobx';
import { MainStore } from './mainStore';
import { DomainStore } from './domainStore';
import { Specification } from '../types';

export class SpecificationStore extends DomainStore<Specification> {
  protected get entityName() {
    return {
      singular: 'Das Pflichtenheft',
      plural: 'Die Pflichtenhefte',
    };
  }

  @computed
  get entities(): Array<Specification> {
    return this.specifications;
  }

  @computed
  get entity(): Specification | undefined {
    return this.specification;
  }

  set entity(holiday: Specification | undefined) {
    this.specification = holiday;
  }

  @observable
  public specifications: Specification[] = [];

  @observable
  public specification?: Specification;

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  @action
  protected async doDelete(id: number) {
    await this.mainStore.api.delete('/specifications/' + id);
    await this.doFetchAll();
  }

  @action
  protected async doFetchAll() {
    const res = await this.mainStore.api.get<Specification[]>('/specifications');
    this.specifications = res.data;
  }

  @action
  protected async doPost(specification: Specification) {
    const response = await this.mainStore.api.post<Specification[]>('/specifications', specification);
    this.specifications = response.data;
  }

  @action
  protected async doPut(specification: Specification) {
    const response = await this.mainStore.api.put<Specification[]>('/specifications/' + specification.id, specification);
    this.specifications = response.data;
  }
}
