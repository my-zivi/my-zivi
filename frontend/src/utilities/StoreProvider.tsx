import * as React from 'react';
import { ApiStore } from '../stores/apiStore';
import { Provider } from 'mobx-react';
import { History } from 'history';
import { MainStore } from '../stores/mainStore';
import { Formatter } from './formatter';
import { HolidayStore } from 'src/stores/holidayStore';
import { ReportSheetStore } from '../stores/reportSheetStore';
import { PaymentStore } from '../stores/paymentStore';
import { UserStore } from 'src/stores/userStore';

interface Props {
  history: History;
}

export class StoreProvider extends React.Component<Props> {
  private stores: {
    apiStore: ApiStore;
    mainStore: MainStore;
    holidayStore: HolidayStore;
    paymentStore: PaymentStore;
    reportSheetStore: ReportSheetStore;
    userStore: UserStore;
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
      reportSheetStore: new ReportSheetStore(mainStore),
      userStore: new UserStore(mainStore),
    };
  }
  render() {
    return <Provider {...this.stores}>{this.props.children}</Provider>;
  }
}
