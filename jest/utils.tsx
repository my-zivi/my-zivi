/* eslint-disable @typescript-eslint/no-explicit-any */
import { mount } from 'enzyme';
import { IApi } from '~/js/shared/Api';
import preact from 'preact';
import { ApiContext } from '~/js/shared/ApiProvider';
import React from 'preact/compat';
import { InstantSearch } from 'react-instantsearch-dom';
import { defer } from 'lodash';
import { mockClient } from '../app/javascript/js/tests/algolia/mocks';

type MountConsumerComponentType = (componentInstance: preact.JSX.Element, targetComponentName?: string) => any;
export const mountConsumerComponent: MountConsumerComponentType = (componentInstance, targetComponentName) => {
  const root = mount(componentInstance);

  if (!targetComponentName) {
    return root;
  }

  return root.find(targetComponentName);
};

type FakeWrapInApiProviderType = (api: IApi) => (wrapped: preact.JSX.Element, component: string) => any;
export const fakeWrapInApiProvider: FakeWrapInApiProviderType = (api: IApi) => (
  (wrapped, component) => mountConsumerComponent(
    (
      <ApiContext.Provider value={api}>
        {wrapped}
      </ApiContext.Provider>
    ),
    component,
  )
);

export const mountInstantSearchClient: MountConsumerComponentType = (componentInstance, targetComponentName?) => mountConsumerComponent(
  <InstantSearch searchClient={mockClient} indexName="JobPosting">
    {componentInstance}
  </InstantSearch>,
  targetComponentName,
);

type DeferredCheck = (rendered: { update: () => void }, callback: () => void | Promise<void>) => Promise<void>;
export const deferredCheck: DeferredCheck = (rendered, callback) => new Promise<void>((resolve, reject) => {
  defer(() => {
    rendered.update();
    const result = callback();
    if (!result) {
      return resolve();
    }

    return result.then(resolve).catch(reject);
  });
});

export const setImmediate = (fn: () => void) => setTimeout(fn, 0);
