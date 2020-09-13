import { FunctionalComponent } from 'preact';
import React from 'preact/compat';
import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';
import TableHeader from './TableHeader';

interface Props {
  servicesList: ServicesList;
}

const OverviewTable: FunctionalComponent<Props> = ({ servicesList }) => (
  <div class="d-table">
    <div>
      <TableHeader servicesList={servicesList}/>
    </div>
  </div>
);

export default OverviewTable;
