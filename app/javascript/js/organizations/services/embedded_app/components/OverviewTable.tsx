import { Component } from 'preact';
import TableHeader from './TableHeader';
import React from 'preact/compat';
import ServicesList from 'js/organizations/services/embedded_app/models/ServicesList';

interface Props {
  servicesList: ServicesList;
}

export class OverviewTable extends Component<Props> {
  render() {
    return (
      <div class="d-table">
        <div>
          <TableHeader servicesList={this.props.servicesList} />
        </div>
      </div>
    );
  }
}
