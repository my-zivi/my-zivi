import { Component, ComponentChild } from 'preact';
import { DATE_FORMATS } from 'js/constants';
import React from 'preact/compat';
import { Service } from 'js/organizations/services/embedded_app/types';
import Spinner from 'js/shared/components/Spinner';
import withApi, { WithApiProps } from 'js/shared/withApiHelper';
import ServicesList from '../models/ServicesList';
import OverviewTable from './OverviewTable';
import CardHeader from './CardHeader';

interface State {
  loading: boolean;
  services: Array<Service>;
}

class ServicesOverviewCard extends Component<WithApiProps, State> {
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
    const services = await this.props.api.fetchServices();

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
        <CardHeader overviewSubtitle={ServicesOverviewCard.getOverviewSubtitle(servicesList)} />

        <div className="card-body services-overview-container">
          <OverviewTable servicesList={servicesList} />
        </div>
      </div>
    );
  }
}

export default withApi(ServicesOverviewCard);
