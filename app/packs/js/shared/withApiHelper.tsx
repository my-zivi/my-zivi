import React from 'preact/compat';
import { IApi } from 'js/shared/Api';
import { ComponentClass, ComponentType } from 'preact';
import { ApiContext } from 'js/shared/ApiProvider';

export type WithApiProps = { api: IApi };
type UnknownProps = Record<string, unknown>;
type withApiHelperType =
  <P extends UnknownProps>(WrappedComponent: ComponentType<P & WithApiProps>) => ComponentClass<P>;

const withApi: withApiHelperType = <P extends UnknownProps>(WrappedComponent: ComponentType<P & WithApiProps>) => (
  class extends React.Component<P> {
    render() {
      return (
        <ApiContext.Consumer>
          {(api) => <WrappedComponent api={api} {...this.props as P} />}
        </ApiContext.Consumer>
      );
    }
  }
);

export default withApi;
