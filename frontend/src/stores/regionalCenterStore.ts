import { computed, observable } from 'mobx';
import { RegionalCenter } from '../types';
import { DomainStore } from './domainStore';

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

  set entities(entities: RegionalCenter[]) {
    this.regionalCenters = entities;
  }

  @observable
  regionalCenters: RegionalCenter[] = [];

  protected entitiesURL = '/regional_centers/';
}
