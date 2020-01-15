import { inject } from 'mobx-react';
import * as React from 'react';
import injectSheet, { WithSheet } from 'react-jss';
import Button from 'reactstrap/lib/Button';
import { ExpenseSheetStore } from '../../../stores/expenseSheetStore';
import { MainStore } from '../../../stores/mainStore';
import { ServiceSpecificationStore } from '../../../stores/serviceSpecificationStore';
import { ServiceStore } from '../../../stores/serviceStore';
import { UserStore } from '../../../stores/userStore';
import { ExpenseSheet, ExpenseSheetState, Service, User } from '../../../types';
import createStyles from '../../../utilities/createStyles';
import { serviceSchema } from '../schemas';
import { ServiceModal } from '../service_modal/ServiceModal';
import ServiceOverviewTable from './ServiceOverviewTable';
import { ServiceSubformExplanationHeader } from './ServiceSubformExplanationHeader';

interface Props extends WithSheet<typeof styles> {
  mainStore?: MainStore;
  expenseSheetStore?: ExpenseSheetStore;
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

@inject('mainStore', 'serviceStore', 'serviceSpecificationStore', 'userStore', 'expenseSheetStore')
class ServiceSubformInner extends React.Component<Props, ServiceSubformState> {
  constructor(props: Props) {
    super(props);

    this.state = { service_id: undefined, new_service: false };
  }

  submitService = (service: Service) => {
    return this.props.serviceStore!.post(serviceSchema.cast(service)).then(() => {
      this.props.userStore!.fetchOne(this.props.user.id);
    });
  }

  confirmService = (service: Service) => {
    return this.props.serviceStore!.doConfirmPut(service.id!).then(() => {
      this.props.userStore!.fetchOne(service.user_id);
    });
  }

  render() {
    const { user, serviceStore, mainStore, userStore, serviceSpecificationStore, expenseSheetStore, classes, theme } = this.props;
    const submitService = this.submitService;
    const confirmService = this.confirmService;

    return (
      <>
        <ServiceSubformExplanationHeader/>
        {user && (
          <div>
            <ServiceOverviewTable
              mainStore={mainStore}
              expenseSheetStore={expenseSheetStore}
              serviceStore={serviceStore}
              userStore={userStore}
              serviceSpecificationStore={serviceSpecificationStore}
              user={user}
              classes={classes}
              serviceModalId={this.state.service_id}
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
              onSubmit={submitService}
              onServiceConfirmed={confirmService}
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
