import React from 'preact/compat';
import { ComponentChild } from 'preact';
import Api, { IApi } from '~/js/shared/Api';

export const ApiContext = React.createContext<IApi>(undefined);

export default class ApiProvider extends React.Component {
  private api = new Api();

  render(): ComponentChild {
    return (
      <ApiContext.Provider value={this.api}>
        {this.props.children}
      </ApiContext.Provider>
    );
  }
}
