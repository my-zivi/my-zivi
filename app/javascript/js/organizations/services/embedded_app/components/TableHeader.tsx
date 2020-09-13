import React from 'preact/compat';
import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';
import { FunctionalComponent } from 'preact';

interface Props {
  servicesList: ServicesList;
}

const TableHeader: FunctionalComponent<Props> = ({ servicesList }) => (
  <div class="d-table-row">
    {servicesList.monthlyGroups.map((monthlyGroup) => (
      <div class="d-table-cell">{monthlyGroup.monthName}</div>
    ))}
  </div>
);

export default TableHeader;
