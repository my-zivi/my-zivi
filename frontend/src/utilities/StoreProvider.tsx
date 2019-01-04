import * as React from 'react';
import { ApiStore } from '../stores/apiStore';
import { Provider } from 'mobx-react';
import { History } from 'history';
import { MainStore } from '../stores/mainStore';

interface Props {
  history: History;
}

export class StoreProvider extends React.Component<Props> {
  private stores: {
    apiStore: ApiStore;
    mainStore: MainStore;
  };

  constructor(props: Props) {
    super(props);

    this.stores = {
      apiStore: new ApiStore(props.history),
      mainStore: new MainStore(),
    };
  }
  render() {
    return <Provider {...this.stores}>{this.props.children}</Provider>;
  }
}
