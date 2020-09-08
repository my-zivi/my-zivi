import React, { Component, h } from 'preact';
import PropTypes from 'prop-types';
import TableHeader from './TableHeader';

export class PlanningTable extends Component {
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

PlanningTable.propTypes = {
  servicesPlan: PropTypes.object,
};
