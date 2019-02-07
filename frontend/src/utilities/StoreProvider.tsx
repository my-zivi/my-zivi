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
import { MissionStore } from 'src/stores/missionStore';
import { SpecificationStore } from 'src/stores/specificationStore';
import { UserFeedbackStore } from '../stores/userFeedbackStore';

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
    userFeedbackStore: UserFeedbackStore;
    userStore: UserStore;
    missionStore: MissionStore;
    specificationStore: SpecificationStore;
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
      userFeedbackStore: new UserFeedbackStore(mainStore),
      userStore: new UserStore(mainStore),
      missionStore: new MissionStore(mainStore),
      specificationStore: new SpecificationStore(mainStore),
    };
  }
  render() {
    return <Provider {...this.stores}>{this.props.children}</Provider>;
  }
}
