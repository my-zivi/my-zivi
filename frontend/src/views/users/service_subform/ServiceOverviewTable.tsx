import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import moment from 'moment';
import * as React from 'react';
import { WithSheet } from 'react-jss';
import { Link } from 'react-router-dom';
import { UncontrolledTooltip } from 'reactstrap';
import Button from 'reactstrap/lib/Button';
import { DeleteButton } from '../../../form/DeleteButton';
import { OverviewTable } from '../../../layout/OverviewTable';
import { MainStore } from '../../../stores/mainStore';
import { ServiceSpecificationStore } from '../../../stores/serviceSpecificationStore';
import { ServiceStore } from '../../../stores/serviceStore';
import { UserStore } from '../../../stores/userStore';
import { Service, ServiceSpecification, User } from '../../../types';
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
  serviceStore?: ServiceStore;
  userStore?: UserStore;
  serviceSpecificationStore?: ServiceSpecificationStore;
  user: User;
  onModalOpen: (service: Service) => void;
  onModalClose: (_?: React.MouseEvent<HTMLButtonElement>) => void;
  serviceModalIsOpen: boolean;
}

function onServiceTableSubmit(serviceStore?: ServiceStore, userStore?: UserStore) {
  return (service: Service) => {
    return serviceStore!.put(serviceSchema.cast(service)).then(() => {
      void userStore!.fetchOne(service.user_id);
    }) as Promise<void>;
  };
}

function renderFeedbackButton(service: Service) {
  if (service.feedback_done || moment().isBefore(moment(service.ending!))) {
    return;
  }

  return (
    <Link to={`/service/${service.id}/feedback`}>
      <Button color={'info'} type={'button'} className="mr-1">
        <FontAwesomeIcon icon={MailSolidIcon} /> <span>Feedback senden</span>
      </Button>
    </Link>
  );
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
    serviceStore,
    classes,
    userStore,
    serviceSpecificationStore,
    onModalOpen,
    onModalClose,
    serviceModalIsOpen,
  } = params;

  return (
    <OverviewTable
      data={user.services}
      columns={[
        {
          id: 'serviceSpecification',
          label: 'Pflichtenheft',
          format: (service: Service) => {
            const spec = serviceSpecificationStore!
              .entities
              .find((specification: ServiceSpecification) => {
                  return specification.identification_number === service.service_specification_identification_number;
                },
              );
            return `${spec ? spec.name : ''} (${service.service_specification_identification_number})`;
          },
        },
        {
          id: 'beginning',
          label: 'Start',
          format: (service: Service) => (service.beginning ? mainStore!.formatDate(service.beginning) : ''),
        },
        {
          id: 'ending',
          label: 'Ende',
          format: (service: Service) => (service.ending ? mainStore!.formatDate(service.ending) : ''),
        },
        {
          id: 'draft_date',
          label: '',
          format: (service: Service) => (
            <>
              <span id={`reportSheetState-${service.id}`}>
                <FontAwesomeIcon
                  icon={service.confirmation_date ? CheckSquareRegularIcon : SquareRegularIcon}
                  color={service.confirmation_date ? 'green' : 'black'}
                />
              </span>
              <UncontrolledTooltip target={`reportSheetState-${service.id}`}>Aufgebot erhalten</UncontrolledTooltip>
            </>
          ),
        },
      ]}
      renderActions={(service: Service) => (
        <div className={classes.hideButtonText}>
          <a className={'btn btn-link'} href={mainStore!.apiURL('services/' + service.id + '/draft', {}, true)} target={'_blank'}>
            <FontAwesomeIcon icon={PrintSolidIcon} /> <span>Drucken</span>
          </a>
          <Button color={'warning'} type={'button'} className="mr-1" onClick={() => onModalOpen(service)}>
            <FontAwesomeIcon icon={EditSolidIcon} /> <span>Bearbeiten</span>
          </Button>
          {renderFeedbackButton(service)}
          {mainStore!.isAdmin() && (
            <>
              <DeleteButton onConfirm={() => onServiceDeleteConfirm(service, serviceStore!, userStore!)}>
                <FontAwesomeIcon icon={TrashAltRegularIcon} /> <span>Löschen</span>
              </DeleteButton>{' '}
              <Button color={'success'} type={'button'}>
                <FontAwesomeIcon icon={PlusSquareRegularIcon} /> <span>Spesenblatt</span>
              </Button>
            </>
          )}
          <ServiceModal
            onSubmit={onServiceTableSubmit(serviceStore, userStore)}
            user={user}
            values={service}
            onClose={onModalClose}
            isOpen={serviceModalIsOpen}
          />
        </div>
      )}
    />
  );
};
