import { computed, observable } from 'mobx';
import { MainStore } from './mainStore';
import { DomainStore } from './domainStore';
import { ReportSheet } from '../types';

export class ReportSheetStore extends DomainStore<ReportSheet> {
  protected get entityName() {
    return {
      singular: 'Das Spesenblatt',
      plural: 'Die Spesenblätter',
    };
  }

  @computed
  get entities(): Array<ReportSheet> {
    return this.reportSheets;
  }

  @computed
  get entity(): ReportSheet | undefined {
    return this.reportSheet;
  }

  set entity(reportSheet: ReportSheet | undefined) {
    this.reportSheet = reportSheet;
  }

  @observable
  public reportSheets: ReportSheet[] = [];

  @observable
  public reportSheet?: ReportSheet;

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  protected async doDelete(id: number) {
    await this.mainStore.api.delete('/report_sheets/' + id);
  }

  protected async doFetchAll(): Promise<void> {
    const res = await this.mainStore.api.get<ReportSheet[]>('/report_sheets');
    this.reportSheets = res.data;
  }

  protected async doFetchOne(id: number) {
    const res = await this.mainStore.api.get<ReportSheet>('/report_sheets/' + id);
    this.reportSheet = res.data;
  }

  protected async doPut(entity: ReportSheet): Promise<void> {
    const res = await this.mainStore.api.put<ReportSheet>('/report_sheets/' + entity.id, entity);
    this.reportSheet = res.data;
  }
}
