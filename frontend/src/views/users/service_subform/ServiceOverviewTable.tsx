import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import moment from 'moment';
import * as React from 'react';
import { WithSheet } from 'react-jss';
import { UncontrolledTooltip } from 'reactstrap';
import Button from 'reactstrap/lib/Button';
import { DeleteButton } from '../../../form/DeleteButton';
import { OverviewTable } from '../../../layout/OverviewTable';
import { ExpenseSheetStore } from '../../../stores/expenseSheetStore';
import { MainStore } from '../../../stores/mainStore';
import { ServiceSpecificationStore } from '../../../stores/serviceSpecificationStore';
import { ServiceStore } from '../../../stores/serviceStore';
import { UserStore } from '../../../stores/userStore';
import { ExpenseSheet, Service, ServiceSpecification, User } from '../../../types';
import {
  CheckSquareRegularIcon,
  EditSolidIcon,
  PlusSquareRegularIcon,
  PrintSolidIcon,
  SquareRegularIcon,
  TrashAltRegularIcon,
} from '../../../utilities/Icon';
import { serviceSchema } from '../schemas';
import { ServiceModal } from '../service_modal/ServiceModal';

interface OverviewTableParams extends WithSheet<string, {}> {
  mainStore?: MainStore;
  expenseSheetStore?: ExpenseSheetStore;
  serviceStore?: ServiceStore;
  userStore?: UserStore;
  serviceSpecificationStore?: ServiceSpecificationStore;
  user: User;
  onModalOpen: (service: Service) => void;
  onModalClose: (_?: React.MouseEvent<HTMLButtonElement>) => void;
  serviceModalId?: number;
}

function onServiceTableSubmit(serviceStore?: ServiceStore, userStore?: UserStore) {
  return (service: Service) => {
    return serviceStore!.put(serviceSchema.cast(service)).then(() => {
      userStore!.fetchOne(service.user_id);
    }) as Promise<void>;
  };
}

function confirmService(serviceStore?: ServiceStore, userStore?: UserStore) {
  return (service: Service) => {
    return serviceStore!.doConfirmPut(service.id!).then(() => {
      userStore!.fetchOne(service.user_id);
    });
  };
}

function onServiceAddExpenseSheet(service: Service, expenseSheetStore: ExpenseSheetStore, userStore: UserStore) {
  expenseSheetStore.createAdditional(service.id!).then(value => {
    userStore.fetchOne(service.user_id);
  });
}

async function onServiceDeleteConfirm(service: Service, serviceStore: ServiceStore, userStore: UserStore) {
  await serviceStore.delete(service.id!);
  await userStore.fetchOne(service.user_id);
}

export default (params: OverviewTableParams) => {
  const {
    user,
    mainStore,
    expenseSheetStore,
    serviceStore,
    classes,
    userStore,
    serviceSpecificationStore,
    onModalOpen,
    onModalClose,
    serviceModalId,
  } = params;

  const columns = [
    {
      id: 'serviceSpecification',
      label: 'Pflichtenheft',
      format: (service: Service) => {
        const spec = serviceSpecificationStore!
          .entities
          .find((specification: ServiceSpecification) => {
              return specification.id === service.service_specification_id;
            },
          );
        return `${spec ? spec.name : ''} (${service.service_specification.identification_number})`;
      },
    },
    {
      id: 'beginning',
      label: 'Start',
      format: (service: Service) => (service.beginning ? mainStore!.formatDate(moment(service.beginning)) : ''),
    },
    {
      id: 'ending',
      label: 'Ende',
      format: (service: Service) => (service.ending ? mainStore!.formatDate(moment(service.ending)) : ''),
    },
    {
      id: 'draft_date',
      label: '',
      format: (service: Service) => (
        <>
          <span id={`expenseSheetState-${service.id}`}>
            <FontAwesomeIcon
              icon={service.confirmation_date ? CheckSquareRegularIcon : SquareRegularIcon}
              color={service.confirmation_date ? 'green' : 'black'}
            />
          </span>
          <UncontrolledTooltip target={`expenseSheetState-${service.id}`}>Aufgebot erhalten</UncontrolledTooltip>
        </>
      ),
    },
  ];

  function printButton(service: Service) {
    return (
      <a
        className={'btn btn-link'}
        href={mainStore!.apiURL('services/' + service.id + '.pdf', {}, true)}
        target={'_blank'}
      >
        <FontAwesomeIcon icon={PrintSolidIcon}/> <span>Drucken</span>
      </a>
    );
  }

  function editButton(service: Service) {
    return (
      <Button color={'warning'} type={'button'} className="mr-1" onClick={() => onModalOpen(service)}>
        <FontAwesomeIcon icon={EditSolidIcon}/> <span>Bearbeiten</span>
      </Button>
    );
  }

  function adminButtons(service: Service) {
    return mainStore!.isAdmin() && (
      <>
        <DeleteButton
          id={service.id ? 'Service-' + service.id.toString() : ''}
          onConfirm={() => onServiceDeleteConfirm(service, serviceStore!, userStore!)}
          disabled={!service.deletable}
          tooltip={service.deletable ? undefined : 'Zuerst Spesenblätter löschen!'}
        >
          <FontAwesomeIcon icon={TrashAltRegularIcon}/> <span>Löschen</span>
        </DeleteButton>{' '}
        {
          service.confirmation_date !== null && (
            <Button
              onClick={() => onServiceAddExpenseSheet(service, expenseSheetStore!, userStore!)}
              color={'success'}
              type={'button'}
            >
              <FontAwesomeIcon icon={PlusSquareRegularIcon}/> <span>Spesenblatt</span>
            </Button>
          )
        }

      </>
    );
  }

  function getOverviewButtons(service: Service) {
    return (
      <>
        {printButton(service)}
        {editButton(service)}
        {adminButtons(service)}
      </>
    );
  }

  function OverViewTableRenderActions() {
    return (service: Service) => (
      <div className={classes.hideButtonText}>
        {getOverviewButtons(service)}
        <ServiceModal
          onSubmit={onServiceTableSubmit(serviceStore, userStore)}
          onServiceConfirmed={confirmService(serviceStore, userStore)}
          user={user}
          service={service}
          onClose={onModalClose}
          isOpen={serviceModalId === service.id}
        />
      </div>
    );
  }

  return (
    <OverviewTable
      data={user.services}
      columns={columns}
      renderActions={OverViewTableRenderActions()}
    />
  );
};
