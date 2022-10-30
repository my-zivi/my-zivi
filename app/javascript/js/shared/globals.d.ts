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

// Allow asset imports in typescript (handled by webpack later)
declare module '*.png' {
  const content: object;
  export default content;
}

declare module '*.jpg' {
  const content: object;
  export default content;
}
