import React, { h, Component } from 'preact';
import Rails from '@rails/ujs';
import PropTypes from 'prop-types';
import { SERVICES_PROP_TYPES } from './PlanningTable';

export default class App extends Component {
  constructor() {
    super();

    this.state = {
      loading: true,
      services: [],
    };
  }

  async componentDidMount() {
    await this.reloadPlanningView();
  }

  async reloadPlanningView() {
    const services = await this.fetchData();

    this.setState({
      loading: false,
      services,
    });
  }

  async fetchData() {
    return new Promise((success, error) => {
      Rails.ajax({
        url: '/organizations/planning.json',
        type: 'GET',
        success,
        error,
      });
    });
  }

  render() {
    if (this.state.loading) {
      return <p>loading...</p>;
    } else {
      return <h1>App</h1>;
    }
  }
}

App.propTypes = {
  loading: PropTypes.bool.isRequired,
  services: PropTypes.arrayOf(SERVICES_PROP_TYPES),
};
