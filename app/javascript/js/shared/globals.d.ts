interface ServicesOverviewTranslations {
  title: string;
  errors: {
    cannotLoad: string;
  };
}

declare interface MyZiviGlobal {
  locale: string;
  translations: {
    loading: string;
    servicesOverview: ServicesOverviewTranslations,
    error: string;
    search: SearchTranslations;
  },
  paths: {
    servicesOverview: string;
  },
  algolia: {
    applicationId: string;
    apiKey: string;
  },
}

declare const MyZivi: MyZiviGlobal;
