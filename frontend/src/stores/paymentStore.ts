import { action, computed, observable } from 'mobx';
import moment from 'moment';
import { ExpenseSheetState, Payment, PaymentState } from '../types';
import { DomainStore } from './domainStore';
import { MainStore } from './mainStore';

export class PaymentStore extends DomainStore<Payment> {
  protected get entityName() {
    return {
      singular: 'Die Auszahlung',
      plural: 'Die Auszahlungen',
    };
  }

  @computed
  get entities(): Payment[] {
    return this.payments;
  }

  @computed
  get entity(): Payment | undefined {
    return this.payment;
  }

  set entity(payment: Payment | undefined) {
    this.payment = payment;
  }

  get paymentsInProgress() {
    return this.payments.filter(payment => payment.state === PaymentState.payment_in_progress);
  }

  get paidPayments() {
    return this.payments.filter(payment => payment.state === PaymentState.paid);
  }

  static convertPaymentTimestamp(timestamp: number) {
    return moment(timestamp * 1000);
  }

  @observable
  payments: Payment[] = [];

  @observable
  payment?: Payment;

  protected entityURL = '/payments/';
  protected entitiesURL = '/payments/';

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  async createPayment() {
    try {
      const res = await this.mainStore.api.post<Payment>('/payments');
      if (this.payments) {
        this.payments.push(res.data);
      }
      this.mainStore.displaySuccess(`${this.entityName.singular} wurde erstellt!`);
    } catch (e) {
      this.mainStore.displayError(
        DomainStore.buildErrorMessage(e, `${this.entityName.singular} konnte nicht erstellt werden`),
      );
    }
  }

  async confirmPayment(paymentTimestamp?: number) {
    try {
      const timestamp = paymentTimestamp || this.payment!.payment_timestamp;
      const res = await this.mainStore.api.put<Payment>(`/payments/${timestamp}/confirm`);
      this.payment = res.data;
      this.mainStore.displaySuccess(`${this.entityName.singular} wurde bestätigt!`);
    } catch (e) {
      this.mainStore.displayError(
        DomainStore.buildErrorMessage(e, `${this.entityName.singular} konnte nicht bestätigt werden`),
      );
    }
  }

  async cancelPayment(paymentTimestamp?: number) {
    try {
      const timestamp = paymentTimestamp || this.payment!.payment_timestamp;
      await this.mainStore.api.delete(`/payments/${timestamp}`);
      this.mainStore.displaySuccess(`${this.entityName.singular} wurde abgebrochen!`);
    } catch (e) {
      this.mainStore.displayError(
        DomainStore.buildErrorMessage(e, `${this.entityName.singular} konnte nicht abgebrochen werden`),
      );
    }
  }

  @action
  async fetchAllWithYearDelta(delta: number) {
    try {
      const res = await this.mainStore.api.get<Payment[]>(`/payments?filter[year_delta]=${delta}`);
      this.payments = [...this.payments, ...res.data];
    } catch (e) {
      this.mainStore.displayError(DomainStore.buildErrorMessage(e, `${this.entityName.plural} konnten nicht geladen werden`));
      // tslint:disable-next-line:no-console
      console.error(e);
      throw e;
    }
  }
}
