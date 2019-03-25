import { computed, observable } from 'mobx';
import { Payment } from '../types';
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

  @observable
  payments: Payment[] = [];

  @observable
  payment?: Payment;

  constructor(mainStore: MainStore) {
    super(mainStore);
  }

  protected async doFetchAll(): Promise<void> {
    const res = await this.mainStore.api.get<Payment[]>('/payments');
    this.payments = res.data;
  }

  protected async doFetchOne(id: number): Promise<void> {
    const res = await this.mainStore.api.get<Payment>('/payments/' + id);
    this.payment = res.data;
  }
}
