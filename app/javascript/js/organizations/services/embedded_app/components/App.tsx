import { Component, ComponentChild } from 'preact';
import { DATE_FORMATS } from 'js/constants';
import React from 'preact/compat';
import moment from 'moment';
import { Service } from 'js/organizations/services/embedded_app/types';
import Api from 'js/organizations/services/embedded_app/Api';
import ServicesList from '../models/ServicesList';
import OverviewTable from './OverviewTable';

interface State {
  loading: boolean;
  services: Array<Service>;
}

export default class App extends Component<unknown, State> {
  constructor() {
    super();

    this.state = {
      loading: true,
      services: [],
    };
  }

  get servicesList(): ServicesList {
    return new ServicesList(this.state.services);
  }

  async componentDidMount(): Promise<void> {
    await this.reloadPlanningView();
  }

  async reloadPlanningView(): Promise<void> {
    const services = await Api.fetchData();

    this.setState({
      loading: false,
      services,
    });
  }

  render(): ComponentChild {
    if (this.state.loading) {
      return <p>loading...</p>;
    }
    const { servicesList } = this;

    (window as any).servicesList = servicesList;
    (window as any).moment = moment;
    (window as any).grouped = servicesList.monthlyGroups;

    return (
      <>
        <h1>
          {servicesList.planBeginning.format(DATE_FORMATS.short)} - {servicesList.planEnding.format(DATE_FORMATS.short)}
        </h1>
        <OverviewTable servicesList={servicesList}/>
      </>
    );
  }
}
