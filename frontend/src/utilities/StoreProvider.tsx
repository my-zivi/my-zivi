import * as React from 'react';
import { ApiStore } from '../stores/apiStore';
import { Provider } from 'mobx-react';
import { History } from 'history';
import { MainStore } from '../stores/mainStore';
import { Formatter } from './formatter';
import { HolidayStore } from 'src/stores/holidayStore';
import { ReportSheetStore } from '../stores/reportSheetStore';

interface Props {
  history: History;
}

export class StoreProvider extends React.Component<Props> {
  private stores: {
    apiStore: ApiStore;
    mainStore: MainStore;
    holidayStore: HolidayStore;
    reportSheetStore: ReportSheetStore;
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
      reportSheetStore: new ReportSheetStore(mainStore),
    };
  }
  render() {
    return <Provider {...this.stores}>{this.props.children}</Provider>;
  }
}
