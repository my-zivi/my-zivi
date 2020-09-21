import { FunctionalComponent } from 'preact';
import React from 'preact/compat';
import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';
import TableContent from 'js/organizations/services/embedded_app/components/TableContent';
import TableHeader from './TableHeader';

interface Props {
  servicesList: ServicesList;
}

const OverviewTable: FunctionalComponent<Props> = ({ servicesList }) => (
  <div className="d-flex">
    {servicesList.monthlyGroups.map((group) => (
      <div className="mr-2">
        <h3 className="text-center">{group.monthName}</h3>
        <div className="d-table">
          <TableHeader monthlyGroup={group} />
          <TableContent monthlyGroup={group} />
        </div>
      </div>
    ))}
  </div>
);

export default OverviewTable;
