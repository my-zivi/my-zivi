import { inject } from 'mobx-react';
import * as React from 'react';
import injectSheet, { WithSheet } from 'react-jss';
import Button from 'reactstrap/lib/Button';
import { MainStore } from '../../../stores/mainStore';
import { ServiceSpecificationStore } from '../../../stores/serviceSpecificationStore';
import { ServiceStore } from '../../../stores/serviceStore';
import { UserStore } from '../../../stores/userStore';
import { Service, User } from '../../../types';
import createStyles from '../../../utilities/createStyles';
import { serviceSchema } from '../schemas';
import { ServiceModal } from '../service_modal/ServiceModal';
import ServiceOverviewTable from './ServiceOverviewTable';
import { ServiceSubformExplanationHeader } from './ServiceSubformExplanationHeader';

interface Props extends WithSheet<typeof styles> {
  mainStore?: MainStore;
  serviceStore?: ServiceStore;
  serviceSpecificationStore?: ServiceSpecificationStore;
  userStore?: UserStore;
  user: User;
}

interface ServiceSubformState {
  service_id?: number;
  new_service: boolean;
}

const styles = () =>
  createStyles({
    hideButtonText: {
      '@media (max-width: 1024px)': {
        '& button': {
          width: '40px',
        },
        '& span': {
          display: 'none',
        },
      },
      'marginTop': '-0.5rem',
    },
  });

@inject('mainStore', 'serviceStore', 'serviceSpecificationStore', 'userStore')
class ServiceSubformInner extends React.Component<Props, ServiceSubformState> {
  constructor(props: Props) {
    super(props);

    this.state = { service_id: undefined, new_service: false };
  }

  render() {
    const { user, serviceStore, mainStore, userStore, serviceSpecificationStore, classes, theme } = this.props;

    return (
      <>
        <ServiceSubformExplanationHeader/>
        {user && (
          <div>
            <ServiceOverviewTable
              mainStore={mainStore}
              serviceStore={serviceStore}
              userStore={userStore}
              serviceSpecificationStore={serviceSpecificationStore}
              user={user}
              classes={classes}
              serviceModalIsOpen={!!this.state.service_id}
              theme={theme}
              onModalClose={() => this.setState({ service_id: undefined })}
              onModalOpen={(service: Service) => this.setState({ service_id: service.id })}
            />

            <Button
              color={'success'}
              type={'button'}
              onClick={() => {
                this.setState({ new_service: true });
              }}
            >
              Neue Einsatzplanung hinzufügen
            </Button>
            <ServiceModal
              onSubmit={(service: Service) => serviceStore!.post(serviceSchema.cast(service))}
              user={user}
              onClose={() => {
                this.setState({ new_service: false });
              }}
              isOpen={this.state.new_service}
            />
          </div>
        )}
        {!user && <div>Loading...</div>}
      </>
    );
  }
}

export const ServiceSubform = injectSheet(styles)(ServiceSubformInner);
