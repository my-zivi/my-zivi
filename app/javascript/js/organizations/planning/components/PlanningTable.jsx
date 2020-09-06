import { Component } from 'preact';
import PropTypes from 'prop-types';

export const SERVICES_PROP_TYPES = PropTypes.shape({
  fullName: PropTypes.string.isRequired,
  services: PropTypes.arrayOf(
    PropTypes.shape({
      beginning: PropTypes.string.isRequired,
      ending: PropTypes.string.isRequired,
    }).isRequired,
  ).isRequired,
}).isRequired;

export class PlanningTable extends Component {
  render() {
    
  }
}

PlanningTable.propTypes = {
  services: PropTypes.arrayOf(SERVICES_PROP_TYPES),
};
