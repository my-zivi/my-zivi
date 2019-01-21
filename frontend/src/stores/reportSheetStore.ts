//tslint:disable:no-console
import { action, computed, observable } from 'mobx';
import { MainStore } from './mainStore';
import { DomainStore } from './domainStore';
import { ReportSheet, ReportSheetListing } from '../types';

export class ReportSheetStore extends DomainStore<ReportSheet, ReportSheetListing> {
  protected get entityName() {
    return {
      singular: 'Das Spesenblatt',
      plural: 'Die Spesenblätter',
    };
  }

  @computed
  get entities(): Array<ReportSheetListing> {
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
  public toBePaidReportSheets: ReportSheet[] = [];

  @observable
  public reportSheets: ReportSheetListing[] = [];

  @observable
  public reportSheet?: ReportSheet;

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  protected async doDelete(id: number) {
    await this.mainStore.api.delete('/report_sheets/' + id);
  }

  protected async doFetchAll(params: object = {}): Promise<void> {
    const res = await this.mainStore.api.get<ReportSheetListing[]>('/report_sheets', { params: { ...params } });
    this.reportSheets = res.data;
  }

  protected async doFetchOne(id: number) {
    const res = await this.mainStore.api.get<ReportSheet>('/report_sheets/' + id);
    this.reportSheet = res.data;
  }

  @action
  public async fetchToBePaidAll(): Promise<void> {
    try {
      this.toBePaidReportSheets = [];
      const response = await this.mainStore.api.get<ReportSheet[]>('/report_sheets', { params: { state: 'ready_for_payment' } });
      this.toBePaidReportSheets = response.data;
    } catch (e) {
      this.mainStore.displayError(`${this.entityName.plural} konnten nicht geladen werden.`);
      console.error(e);
      throw e;
    }
  }

  protected async doPut(entity: ReportSheet): Promise<void> {
    const res = await this.mainStore.api.put<ReportSheet>('/report_sheets/' + entity.id, entity);
    this.reportSheet = res.data;
  }

  @action
  public async putState(id: number, state: number): Promise<void> {
    return this.displayLoading(async () => {
      await this.mainStore.api.put<ReportSheet>('/report_sheets/' + id + '/state', { state });
      this.mainStore.displaySuccess(`${this.entityName.singular} wurde bestätigt.`);
    });
  }
}
