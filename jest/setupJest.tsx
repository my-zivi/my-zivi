/* eslint-disable @typescript-eslint/no-explicit-any */
import { configure } from 'enzyme';
import Adapter from 'enzyme-adapter-preact-pure';
import { h, Fragment } from 'preact';
// eslint-disable-next-line import/no-unresolved

(global as any).h = h;
(global as any).Fragment = Fragment;

const globalConfig: MyZiviGlobal = {
  translations: {
    servicesOverview: {
      title: 'My Services Overview',
    },
    loading: 'Laden...',
  },
  paths: {
    servicesOverview: '/my/mock/services.json',
  },
};
(global as any).MyZivi = globalConfig;

jest.mock('@rails/ujs', () => jest.requireActual('js/shared/__mocks__/Rails'));

configure({ adapter: new Adapter() });
