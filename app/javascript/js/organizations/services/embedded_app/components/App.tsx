import ApiProvider from '~/js/shared/ApiProvider.tsx';
import ServicesOverviewCard from '~/js/organizations/services/embedded_app/components/ServicesOverviewCard.tsx';
import React from 'preact/compat';

const App: React.FunctionComponent = () => (
  <ApiProvider>
    <ServicesOverviewCard />
  </ApiProvider>
);

export default App;
