// tslint:disable:no-console
import { action, computed, observable } from 'mobx';
import { ExpenseSheet, ExpenseSheetHints, ExpenseSheetListing, ExpenseSheetState } from '../types';
import { DomainStore } from './domainStore';
import { MainStore } from './mainStore';

export class ExpenseSheetStore extends DomainStore<ExpenseSheet, ExpenseSheetListing> {
  protected get entityName() {
    return {
      singular: 'Das Spesenblatt',
      plural: 'Die Spesenblätter',
    };
  }

  @computed
  get entities(): ExpenseSheetListing[] {
    return this.expenseSheets;
  }

  @computed
  get entity(): ExpenseSheet | undefined {
    return this.expenseSheet;
  }

  set entity(expenseSheet: ExpenseSheet | undefined) {
    this.expenseSheet = expenseSheet;
  }

  @observable
  toBePaidExpenseSheets: ExpenseSheet[] = [];

  @observable
  expenseSheets: ExpenseSheetListing[] = [];

  @observable
  expenseSheet?: ExpenseSheet;

  hints?: ExpenseSheetHints;

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  @action
  async fetchToBePaidAll(): Promise<void> {
    try {
      this.toBePaidExpenseSheets = [];
      const response = await this.mainStore.api.get<ExpenseSheet[]>('/expense_sheets', { params: { filter: 'ready_for_payment' } });
      this.toBePaidExpenseSheets = response.data;
    } catch (e) {
      this.mainStore.displayError(`${this.entityName.plural} konnten nicht geladen werden.`);
      console.error(e);
      throw e;
    }
  }

  @action
  async putState(id: number, state: ExpenseSheetState): Promise<void> {
    return this.displayLoading(async () => {
      await this.mainStore.api.put<ExpenseSheet>('/expense_sheets/' + id + '/state', { state });
      this.mainStore.displaySuccess(`${this.entityName.singular} wurde bestätigt.`);
    });
  }

  async fetchHints(expenseSheetId: number) {
    try {
      const response = await this.mainStore.api.get<ExpenseSheetHints>(`/expense_sheets/${expenseSheetId}/hints`);
      this.hints = response.data;
    } catch (e) {
      this.mainStore.displayError('Spesenvorschläge konnten nicht geladen werden');
      console.error(e);
      throw e;
    }
  }

  protected async doDelete(id: number) {
    await this.mainStore.api.delete('/expense_sheets/' + id);
  }

  protected async doFetchAll(params: object = {}): Promise<void> {
    const res = await this.mainStore.api.get<ExpenseSheetListing[]>('/expense_sheets', { params: { ...params } });
    this.expenseSheets = res.data;
  }

  protected async doFetchOne(id: number) {
    const res = await this.mainStore.api.get<ExpenseSheet>('/expense_sheets/' + id);
    this.expenseSheet = res.data;
  }

  protected async doPut(entity: ExpenseSheet): Promise<void> {
    const res = await this.mainStore.api.put<ExpenseSheet>('/expense_sheets/' + entity.id, entity);
    this.expenseSheet = res.data;
  }
}
