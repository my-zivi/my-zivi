import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import moment from 'moment';
import * as React from 'react';
import { WithSheet } from 'react-jss';
import { Link } from 'react-router-dom';
import { UncontrolledTooltip } from 'reactstrap';
import Button from 'reactstrap/lib/Button';
import { DeleteButton } from '../../../form/DeleteButton';
import { OverviewTable } from '../../../layout/OverviewTable';
import { ExpenseSheetStore } from '../../../stores/expenseSheetStore';
import { MainStore } from '../../../stores/mainStore';
import { ServiceSpecificationStore } from '../../../stores/serviceSpecificationStore';
import { ServiceStore } from '../../../stores/serviceStore';
import { UserStore } from '../../../stores/userStore';
import { ExpenseSheet, ExpenseSheetState, Service, ServiceSpecification, User } from '../../../types';
import {
  CheckSquareRegularIcon,
  EditSolidIcon,
  MailSolidIcon,
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
      void userStore!.fetchOne(service.user_id);
    }) as Promise<void>;
  };
}

const expenseSheetTemplate: ExpenseSheet = {
  bank_account_number: '',
  beginning: new Date(),
  clothing_expenses: 0,
  clothing_expenses_comment: null,
  company_holiday_comment: null,
  driving_expenses: 0,
  driving_expenses_comment: null,
  duration: 0,
  ending: new Date(),
  extraordinary_expenses: 0,
  extraordinary_expenses_comment: null,
  id: 0,
  paid_company_holiday_days: 0,
  paid_vacation_comment: null,
  paid_vacation_days: 0,
  payment_timestamp: null,
  service_id: 0,
  sick_comment: null,
  sick_days: 0,
  state: ExpenseSheetState.open,
  total: 0,
  unpaid_company_holiday_days: 0,
  unpaid_vacation_comment: null,
  unpaid_vacation_days: 0,
  user_id: 0,
  work_days: 0,
  workfree_days: 0,
};

function onServiceAddExpenseSheet(service: Service, expenseSheetStore: ExpenseSheetStore) {
  expenseSheetStore.post(expenseSheetTemplate).then(window.location.reload);
}

async function onServiceDeleteConfirm(service: Service, serviceStore: ServiceStore, userStore: UserStore) {
  console.dir(service); // tslint:disable-line
  (window as any).service = service;
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
        <DeleteButton onConfirm={() => onServiceDeleteConfirm(service, serviceStore!, userStore!)}>
          <FontAwesomeIcon icon={TrashAltRegularIcon}/> <span>Löschen</span>
        </DeleteButton>{' '}
        <Button
          onClick={() => onServiceAddExpenseSheet(service, expenseSheetStore!)}
          color={'success'}
          type={'button'}
        >
          <FontAwesomeIcon icon={PlusSquareRegularIcon}/> <span>Spesenblatt</span>
        </Button>
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
          user={user}
          values={service}
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
