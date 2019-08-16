import { computed, observable } from 'mobx';
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

  protected async doFetchAll(): Promise<void> {
    const res = await this.mainStore.api.get<Payment[]>('/payments');
    this.payments = res.data;
  }

  protected async doFetchOne(timestamp: number): Promise<void> {
    const res = await this.mainStore.api.get<Payment>('/payments/' + timestamp);
    this.payment = res.data;
  }
}
