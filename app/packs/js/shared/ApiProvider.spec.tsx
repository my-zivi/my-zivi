import React from 'preact/compat';
import withApi from 'js/shared/withApiHelper';
import ApiProvider from 'js/shared/ApiProvider';
import { mountConsumer } from '../../../../jest/utils';

describe('ApiProvider', () => {
  const TestComponent: React.FunctionComponent = () => <span>Test</span>;
  const WrappedTestComponent = withApi(TestComponent);
  const proxy = mountConsumer(<ApiProvider><WrappedTestComponent /></ApiProvider>, 'TestComponent');

  it('provides an api', () => {
    expect(proxy.props().api).toBeDefined();
  });
});
