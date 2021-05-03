import { FunctionalComponent } from 'preact';
import React from 'preact/compat';
import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';
import TableContent from 'js/organizations/services/embedded_app/components/TableContent';
import NamesList from 'js/organizations/services/embedded_app/components/NamesList';
import TableHeader from './TableHeader';

interface Props {
  servicesList: ServicesList;
}

const OverviewTable: FunctionalComponent<Props> = ({ servicesList }) => (
  <div className="d-flex">
    <NamesList servicesList={servicesList} />
    {servicesList.monthlyGroups.map((group) => (
      <div className="monthly-table-container">
        <h3 className="text-center month-title">{group.monthName}</h3>
        <div className="d-table services-overview-month-table">
          <TableHeader monthlyGroup={group} />
          <TableContent currentMonthlyGroup={group} servicesList={servicesList} />
        </div>
      </div>
    ))}
  </div>
);

export default OverviewTable;
