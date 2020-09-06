import React, { h, Component, Fragment } from 'preact';
import Rails from '@rails/ujs';
import { PlanningTable } from './PlanningTable';
import ServicesPlan from '../models/ServicesPlan';

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

  servicesPlan() {
    return new ServicesPlan(this.state.services);
  }

  render() {
    if (this.state.loading) {
      return <p>loading...</p>;
    } else {
      const plan = this.servicesPlan();

      return(
        <>
          <h1>{plan.planBeginning} - {plan.planEnding}</h1>
          <PlanningTable servicesPlan={plan} />
        </>
      );
    }
  }
}
