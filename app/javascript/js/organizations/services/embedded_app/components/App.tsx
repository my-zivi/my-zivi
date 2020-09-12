import { Component } from 'preact';
import Rails from '@rails/ujs';
import { OverviewTable } from './OverviewTable';
import ServicesList, { Service } from '../models/ServicesList';
import { DATE_FORMATS } from 'js/constants';
import React from 'preact/compat';

interface State {
  loading: boolean;
  services: Array<Service>;
}

export default class App extends Component<{}, State> {
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
    return new ServicesList(this.state.services);
  }

  render() {
    if (this.state.loading) {
      return <p>loading...</p>;
    } else {
      const servicesList = this.servicesPlan();

      return(
        <>
          <h1>
            {servicesList.planBeginning.format(DATE_FORMATS.short)} - {servicesList.planEnding.format(DATE_FORMATS.short)}
          </h1>
          <OverviewTable servicesList={servicesList} />
        </>
      );
    }
  }
}
