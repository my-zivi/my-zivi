import React from 'preact/compat';
import ServicesOverviewCard from './ServicesOverviewCard';
import ApiProvider from '../../../../shared/ApiProvider';

const App: React.FunctionComponent = () => (
  <ApiProvider>
    <ServicesOverviewCard />
  </ApiProvider>
);

export default App;
