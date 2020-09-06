import React, { h, Component } from 'preact';
import Rails from '@rails/ujs';
import PropTypes from 'prop-types';

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
    return new Promise((resolve, reject) => {
      Rails.ajax({
        url: '/organizations/planning.json',
        type: 'GET',
        success: resolve,
        error: reject,
      });
    });
  }

  render() {
    if (this.state.loading) {
      return <p>loading</p>;
    } else {
      return <h1>App</h1>;
    }
  }
}

App.propTypes = {
  loading: PropTypes.bool.isRequired,
  services: PropTypes.shape({
    fullName: PropTypes.string.isRequired,
    services: PropTypes.arrayOf(
      PropTypes.shape({
        beginning: PropTypes.string.isRequired,
        ending: PropTypes.string.isRequired,
      }).isRequired,
    ).isRequired,
  }).isRequired,
};
