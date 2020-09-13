import React from 'preact/compat';
import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';

interface Props {
  servicesList: ServicesList;
}

export default ({ servicesList }: Props) => {
  return (
    <div class="d-table-row">
      {servicesList.monthlyGroups.map(monthlyGroup => (
        <div class="d-table-cell">{monthlyGroup.monthName}</div>
      ))}
    </div>
  );
}
