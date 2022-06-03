import React from 'preact/compat';
import ApiProvider from '~/js/shared/ApiProvider';
import ServicesOverviewCard from '~/js/organizations/services/embedded_app/components/ServicesOverviewCard';

const App: React.FunctionComponent = () => (
  <ApiProvider>
    <ServicesOverviewCard />
  </ApiProvider>
);

export default App;
