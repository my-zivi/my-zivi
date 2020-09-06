import React, { Component, h } from 'preact';
import PropTypes from 'prop-types';

export class PlanningTable extends Component {
  render() {
    return <p>{this.props.servicesPlan.earliestBeginning.format()}-{this.props.servicesPlan.latestEnding.format()}</p>;
  }
}

PlanningTable.propTypes = {
  servicesPlan: PropTypes.object,
};
