declare type MyZiviGlobal = {
  locale: string;
  translations: {
    loading: string;
    servicesOverview: {
      title: string;
      errors: {
        cannotLoad: string;
      }
    },
    error: string;
  },
  paths: {
    servicesOverview: string;
  }
};

declare const MyZivi: MyZiviGlobal;
