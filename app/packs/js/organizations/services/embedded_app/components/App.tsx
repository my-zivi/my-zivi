import ApiProvider from 'js/shared/ApiProvider';
import ServicesOverviewCard from 'js/organizations/services/embedded_app/components/ServicesOverviewCard';
import React from 'preact/compat';

const App: React.FunctionComponent = () => (
  <ApiProvider>
    <ServicesOverviewCard />
  </ApiProvider>
);

export default App;
