import { mount } from 'enzyme';
import { IApi } from 'js/shared/Api';
import preact from 'preact';
import { ApiContext } from 'js/shared/ApiProvider';
import React from 'preact/compat';

type MountConsumerType = (componentInstance: preact.JSX.Element, targetComponentName: string) => any;
export const mountConsumer: MountConsumerType = (componentInstance, targetComponentName) => {
  const root = mount(componentInstance);

  return root.find(targetComponentName);
};

type FakeWrapInApiProviderType = (api: IApi) => (wrapped: preact.JSX.Element, component: string) => any;
export const fakeWrapInApiProvider: FakeWrapInApiProviderType = (api: IApi) => (
  (wrapped, component) => mountConsumer(
    (
      <ApiContext.Provider value={api}>
        {wrapped}
      </ApiContext.Provider>
    ),
    component,
  )
);
