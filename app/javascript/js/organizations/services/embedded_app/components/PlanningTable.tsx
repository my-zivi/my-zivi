import { Component, h } from 'preact';
import TableHeader from './TableHeader';
import ServicesPlan from 'js/organizations/services/embedded_app/models/ServicesPlan';
import React from 'preact/compat';

interface Props {
  servicesPlan: ServicesPlan;
}

export class PlanningTable extends Component<Props> {
  render() {
    return (
      <table>
        <thead>
          <TableHeader servicesPlan={this.props.servicesPlan} />
        </thead>
      </table>
    );
  }
}
