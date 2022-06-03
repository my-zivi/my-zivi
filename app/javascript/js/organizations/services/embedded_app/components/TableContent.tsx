import React from 'preact/compat';
import { FunctionalComponent } from 'preact';
import MonthlyGroup from '~/js/organizations/services/embedded_app/models/MonthlyGroup';
import ServicesList from '~/js/organizations/services/embedded_app/models/ServicesList';
import { Service } from '~/js/organizations/services/embedded_app/types';
import { Moment } from 'moment';

interface Props {
  servicesList: ServicesList;
  currentMonthlyGroup: MonthlyGroup;
}

function activeCell({ definitive }: Service) {
  return (
    <div className={`d-table-cell day-cell active ${definitive ? 'definitive' : 'tentative'}`}>
      {definitive ? <i class="fas fa-check" /> : <i class="far fa-envelope"/>}
    </div>
  );
}

function inactiveCell() {
  return <div className="d-table-cell day-cell inactive" />;
}

function cellForDay(day: Moment, service: Service) {
  const isBetween = day.isBetween(service.beginning, service.ending, 'day', '[]');

  return isBetween ? activeCell(service) : inactiveCell();
}

function renderService(currentMonthlyGroup: MonthlyGroup, service: Service) {
  return (
    <div className="d-table-row">
      {currentMonthlyGroup.mapDays((day) => cellForDay(day, service))}
    </div>
  );
}

const TableContent: FunctionalComponent<Props> = ({ currentMonthlyGroup, servicesList }) => (
  <>
    {servicesList.services.map((service) => renderService(currentMonthlyGroup, service))}
  </>
);

export default TableContent;
