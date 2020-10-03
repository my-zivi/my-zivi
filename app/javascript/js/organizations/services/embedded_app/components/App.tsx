import { Component, ComponentChild } from 'preact';
import { DATE_FORMATS } from 'js/constants';
import React from 'preact/compat';
import { Service } from 'js/organizations/services/embedded_app/types';
import Api from 'js/shared/Api';
import Spinner from 'js/shared/components/Spinner';
import ServicesList from '../models/ServicesList';
import OverviewTable from './OverviewTable';
import CardHeader from './CardHeader';

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
    const services = await Api.fetchServices();

    this.setState({
      loading: false,
      services,
    });
  }

  private static getOverviewSubtitle(servicesList: ServicesList): string {
    const formattedBeginning = servicesList.planBeginning.format(DATE_FORMATS.short);
    const formattedEnding = servicesList.planEnding.format(DATE_FORMATS.short);

    return `${formattedBeginning} bis ${formattedEnding}`;
  }

  render(): ComponentChild {
    if (this.state.loading) {
      return (
        <div className="card mb-3 mb-lg-0">
          <CardHeader overviewSubtitle={MyZivi.translations.loading} />
          <div className="card-body">
            <Spinner style={'info'} />
          </div>
        </div>
      );
    }
    const { servicesList } = this;

    return (
      <div className="card mb-3 mb-lg-0">
        <CardHeader overviewSubtitle={App.getOverviewSubtitle(servicesList)} />

        <div className="card-body services-overview-container">
          <OverviewTable servicesList={servicesList} />
        </div>
      </div>
    );
  }
}
