import { Formik, FormikProps } from 'formik';
import debounce from 'lodash.debounce';
import { inject } from 'mobx-react';
import moment from 'moment';
import * as React from 'react';
import Button from 'reactstrap/lib/Button';
import Modal from 'reactstrap/lib/Modal';
import ModalBody from 'reactstrap/lib/ModalBody';
import ModalFooter from 'reactstrap/lib/ModalFooter';
import ModalHeader from 'reactstrap/lib/ModalHeader';
import { apiDateFormat } from '../../../stores/apiStore';
import { MainStore } from '../../../stores/mainStore';
import { ServiceStore } from '../../../stores/serviceStore';
import { Service, User } from '../../../types';
import { OnChange } from '../../../utilities/Effect';
import { ServiceModalForm } from './ServiceModalForm';

export interface ServiceModalProps<T> {
  onSubmit: (values: T) => Promise<void>;
  user: User;
  values?: Service;
  onClose: (e?: React.MouseEvent<HTMLButtonElement>) => void;
  isOpen: boolean;
  serviceStore?: ServiceStore;
  mainStore?: MainStore;
}

@inject('serviceStore', 'mainStore')
export class ServiceModal extends React.Component<ServiceModalProps<Service>> {
  private readonly initialValues: Service;
  private autoUpdate = true;

  private changeMapToUpdateField = [
    {
      changes: ['beginning', 'ending'],
      updateField: 'service_days',
    },
    {
      changes: ['beginning', 'service_days'],
      updateField: 'ending',
    },
  ];

  private updateEndingOrServiceDays = debounce(async (current, next, formik) => {
    this.autoUpdate = false;
    const values = {
      beginning: next.values.beginning,
    };
    for (const map of this.changeMapToUpdateField) {
      const [firstIndex, secondIndex] = map.changes;

      if (!next.values[firstIndex] || !next.values[secondIndex]) {
        continue;
      }

      const firstIndexUnchanged = current.values[firstIndex] === next.values[firstIndex];
      const secondIndexUnchanged = current.values[secondIndex] === next.values[secondIndex];
      if (firstIndexUnchanged && secondIndexUnchanged) {
        continue;
      }

      values[secondIndex] = next.values[secondIndex];
      const data = await this.props.serviceStore!.calcServiceDaysOrEnding(values);
      if (data && data.result) {
        formik.setFieldValue(map.updateField, data.result);
      }
      break;
    }
    this.autoUpdate = true;
  }, 500);

  constructor(props: ServiceModalProps<Service>) {
    super(props);
    this.initialValues = props.values || {
      service_specification_id: -1,
      service_type: 'normal',
      beginning: null,
      ending: null,
      service_days: 0,
      first_swo_service: false,
      long_service: false,
      probation_period: false,
      confirmation_date: null,
      eligible_paid_vacation_days: 0,
      user_id: props.user.id,
      service_specification: {
        identification_number: -1,
        name: undefined,
        short_name: undefined,
      },
    };
  }

  handleServiceDateRangeChange: OnChange<Service> = async (current, next, formik) => {
    if (this.autoUpdate) {
      await this.updateEndingOrServiceDays(current, next, formik);
    }
  }

  render() {
    const { onSubmit, onClose, isOpen, mainStore } = this.props;

    if (!isOpen) {
      return <></>;
    }

    return (
      <Formik
        onSubmit={onSubmit}
        initialValues={this.initialValues}
        render={(formikProps: FormikProps<Service>) => (
          <Modal isOpen toggle={onClose}>
            <ModalHeader toggle={onClose}>Zivildiensteinsatz</ModalHeader>
            <ModalBody>
              <ServiceModalForm serviceDateRangeChangeHandler={this.handleServiceDateRangeChange} isAdmin={mainStore!.isAdmin()}/>
            </ModalBody>
            <ModalFooter>
              <Button color="primary" onClick={formikProps.submitForm}>
                Daten speichern
              </Button>
              {(this.props.mainStore!.isAdmin() && this.props.values && this.props.values.confirmation_date == null) && (
                <>
                  {' '}
                  <Button color="secondary">Aufgebot erhalten</Button>
                </>
              )}
            </ModalFooter>
          </Modal>
        )}
      />
    );
  }
}
