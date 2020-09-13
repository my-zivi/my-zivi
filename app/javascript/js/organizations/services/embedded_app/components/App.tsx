import { Component } from 'preact';
import { OverviewTable } from './OverviewTable';
import ServicesList from '../models/ServicesList';
import { DATE_FORMATS } from 'js/constants';
import React from 'preact/compat';
import moment from "moment";
import { Service } from 'js/organizations/services/embedded_app/types';
import Api from 'js/organizations/services/embedded_app/Api';

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
    const services = await Api.fetchData();

    this.setState({
      loading: false,
      services,
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

      (window as any).servicesList = servicesList;
      (window as any).moment = moment;
      (window as any).grouped = servicesList.monthlyGroups;

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
