import { History } from 'history';
import { Provider } from 'mobx-react';
import * as React from 'react';
import { ApiStore } from '../stores/apiStore';
import { ExpenseSheetStore } from '../stores/expenseSheetStore';
import { HolidayStore } from '../stores/holidayStore';
import { MainStore } from '../stores/mainStore';
import { PaymentStore } from '../stores/paymentStore';
import { RegionalCenterStore } from '../stores/regionalCenterStore';
import { ServiceSpecificationStore } from '../stores/serviceSpecificationStore';
import { ServiceStore } from '../stores/serviceStore';
import { UserFeedbackStore } from '../stores/userFeedbackStore';
import { UserStore } from '../stores/userStore';
import { Formatter } from './formatter';

interface Props {
  history: History;
}

export class StoreProvider extends React.Component<Props> {
  private stores: {
    apiStore: ApiStore;
    mainStore: MainStore;
    holidayStore: HolidayStore;
    paymentStore: PaymentStore;
    expenseSheetStore: ExpenseSheetStore;
    userFeedbackStore: UserFeedbackStore;
    userStore: UserStore;
    serviceStore: ServiceStore;
    serviceSpecificationStore: ServiceSpecificationStore;
    regionalCenterStore: RegionalCenterStore;
  };

  constructor(props: Props) {
    super(props);

    const apiStore = new ApiStore(this.props.history);
    const formatter = new Formatter();
    const mainStore = new MainStore(apiStore, formatter, this.props.history);

    this.stores = {
      apiStore,
      mainStore,
      holidayStore: new HolidayStore(mainStore),
      paymentStore: new PaymentStore(mainStore),
      expenseSheetStore: new ExpenseSheetStore(mainStore),
      userFeedbackStore: new UserFeedbackStore(mainStore),
      userStore: new UserStore(mainStore),
      serviceStore: new ServiceStore(mainStore),
      serviceSpecificationStore: new ServiceSpecificationStore(mainStore),
      regionalCenterStore: new RegionalCenterStore(mainStore),
    };
  }
  render() {
    return <Provider {...this.stores}>{this.props.children}</Provider>;
  }
}
