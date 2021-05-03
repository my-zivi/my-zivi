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
  error: string | undefined;
}

export class ServicesOverviewCardImpl extends Component<WithApiProps, State> {
  constructor() {
    super();

    this.state = {
      loading: true,
      services: [],
      error: null,
    };
  }

  get servicesList(): ServicesList {
    return new ServicesList(this.state.services);
  }

  async componentDidMount(): Promise<void> {
    await this.reloadPlanningView();
  }

  async reloadPlanningView(): Promise<void> {
    try {
      const services = await this.props.api.fetchServices();

      this.setState({
        loading: false,
        services,
      });
    } catch (e) {
      let cause = MyZivi.translations.servicesOverview.errors.cannotLoad;
      if (typeof e === 'object' && 'error' in e) {
        cause = `${cause} (${e.error})`;
      }

      this.setState({
        loading: false,
        error: cause,
      });
    }
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

    if (this.state.error) {
      return (
        <div className="card mb-3 mb-lg-0">
          <CardHeader overviewSubtitle={MyZivi.translations.error} />
          <div className="card-body">
            {this.state.error}
          </div>
        </div>
      );
    }

    const { servicesList } = this;

    return (
      <div className="card mb-3 mb-lg-0">
        <CardHeader overviewSubtitle={ServicesOverviewCardImpl.getOverviewSubtitle(servicesList)} />

        <div className="card-body services-overview-container">
          <OverviewTable servicesList={servicesList} />
        </div>
      </div>
    );
  }
}

export default withApi(ServicesOverviewCardImpl);
