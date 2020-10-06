declare type MyZiviGlobal = {
  locale: string;
  translations: {
    loading: string;
    servicesOverview: {
      title: string;
    }
  },
  paths: {
    servicesOverview: string;
  }
};

declare const MyZivi: MyZiviGlobal;
