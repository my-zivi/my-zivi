import React from 'preact/compat';
import Api from 'js/shared/Api';
import { ComponentChild } from 'preact';

export const ApiContext = React.createContext<Api>(undefined);

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
