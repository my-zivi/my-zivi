import { h, Component, Fragment } from 'preact';
import Rails from '@rails/ujs';
import { PlanningTable } from './PlanningTable';
import ServicesPlan, { Service } from '../models/ServicesPlan';
import { DATE_FORMATS } from 'js/constants';
import React from 'preact/compat';

export default class App extends Component<{}, { loading: boolean, services: Array<Service> }> {
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
    return new Promise((success: (services: Service[]) => void, error) => {
      Rails.ajax({
        url: '/organizations/services.json',
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
          <h1>{plan.planBeginning.format(DATE_FORMATS.short)} - {plan.planEnding.format(DATE_FORMATS.short)}</h1>
          <PlanningTable servicesPlan={plan} />
        </>
      );
    }
  }
}
