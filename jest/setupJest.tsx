/* eslint-disable @typescript-eslint/no-explicit-any */
import { configure } from 'enzyme';
import Adapter from 'enzyme-adapter-preact-pure';
import React, { h, Fragment } from 'preact';
import '../app/javascript/js/shared/globals.d';

(global as any).h = h;
(global as any).Fragment = Fragment;

const globalConfig: MyZiviGlobal = {
  locale: 'de',
  translations: {
    servicesOverview: {
      title: 'My Services Overview',
      errors: {
        cannotLoad: 'Konnte die Einsätze nicht laden',
      },
    },
    search: {
      loadMore: 'string',
      noResultsFound: 'string',
      poweredBy: 'string',
      refinements: {
        canton: 'string',
        category: 'string',
        collapseButton: 'string',
        controls: {
          noResults: 'string',
          placeholder: 'string',
          reset: 'string',
          resetTitle: 'string',
          showLess: 'string',
          showMore: 'string',
          submitTitle: 'string',
        },
        language: 'string',
        languages: {
          french: 'string',
          german: 'string',
          italian: 'string',
        },
        month: {
          one: 'string',
          other: 'string',
        },
        minimumServiceMonths: 'string',
        priorityProgram: 'string',
        priorityProgramLabel: 'string',
      },
      ribbons: {
        featured: 'Feat.',
        featuredFull: 'Featured',
        new: 'Neu',
        urgent: 'Wichtig',
      },
      search: 'string',
      searchPlaceholder: 'string',
      statistics: 'string',
      searchView: {
        map: 'Karte',
        tiles: 'Raster',
      },
    } as any,
    loading: 'Laden...',
    error: 'Fehler',
  },
  paths: {
    servicesOverview: '/my/mock/services.json',
  },
  algolia: {
    apiKey: 'my-api-key',
    applicationId: 'my-application-id',
  },
};
(global as any).MyZivi = globalConfig;

jest.mock('@rails/ujs', () => jest.requireActual('js/shared/__mocks__/Rails'));

jest.mock('@fortawesome/react-fontawesome', () => {
  const component: React.FunctionComponent<any> = () => <></>;
  component.displayName = 'FontAwesomeIcon';
  return {
    FontAwesomeIcon: component,
  };
});

configure({ adapter: new Adapter() });
