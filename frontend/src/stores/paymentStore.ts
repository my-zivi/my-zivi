import { computed, observable } from 'mobx';
import { MainStore } from './mainStore';
import { DomainStore } from './domainStore';
import { Payment } from '../types';

export class PaymentStore extends DomainStore<Payment> {
  protected get entityName() {
    return {
      singular: 'Die Auszahlung',
      plural: 'Die Auszahlungen',
    };
  }

  @computed
  get entities(): Array<Payment> {
    return this.payments;
  }

  @computed
  get entity(): Payment | undefined {
    return this.payment;
  }

  set entity(payment: Payment | undefined) {
    this.payment = payment;
  }

  @observable
  public payments: Payment[] = [];

  @observable
  public payment?: Payment;

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  protected async doFetchAll(): Promise<void> {
    const res = await this.mainStore.api.get<Payment[]>('/payments');
    this.payments = res.data;
  }
}
