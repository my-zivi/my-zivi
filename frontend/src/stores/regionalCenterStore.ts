import { action, computed, observable } from 'mobx';
import { RegionalCenter } from '../types';
import { DomainStore } from './domainStore';
import { MainStore } from './mainStore';

export class RegionalCenterStore extends DomainStore<RegionalCenter> {
  protected get entityName() {
    return {
      singular: 'Das Regionalzentrum',
      plural: 'Die Regionalzentren',
    };
  }

  @computed
  get entities(): RegionalCenter[] {
    return this.regionalCenters;
  }

  @observable
  regionalCenters: RegionalCenter[] = [];

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  @action
  protected async doFetchAll() {
    const res = await this.mainStore.api.get<RegionalCenter[]>('/regional_centers');
    this.regionalCenters = res.data;
  }
}
