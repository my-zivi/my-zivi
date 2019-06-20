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

  private updateDays = debounce(async (start: string, end: string, formik: FormikProps<Service>) => {
    this.autoUpdate = false;
    const data = await this.props.serviceStore!.calcEligibleDays(moment(start).format(apiDateFormat), moment(end).format(apiDateFormat));
    if (data) {
      formik.setFieldValue('days', data);
    }
    this.autoUpdate = true;
  }, 500);

  private updateEnd = debounce(async (start: string, days: number, formik: FormikProps<Service>) => {
    this.autoUpdate = false;
    const data = await this.props.serviceStore!.calcPossibleEndDate(moment(start).format(apiDateFormat), days);
    if (data) {
      formik.setFieldValue('ending', data);
    }
    this.autoUpdate = true;
  }, 500);

  constructor(props: ServiceModalProps<Service>) {
    super(props);
    this.initialValues = props.values || {
      specification_id: '',
      service_type: 0,
      beginning: null,
      ending: null,
      days: 0,
      first_swo_service: false,
      long_service: false,
      probation_period: false,
      confirmation_date: null,
      eligible_holiday: 0,
      feedback_done: false,
      feedback_mail_sent: false,
      user_id: props.user.id,
    };
  }

  handleServiceDateRangeChange: OnChange<Service> = async (current, next, formik) => {
    if (this.autoUpdate) {
      if (current.values.beginning !== next.values.beginning || current.values.ending !== next.values.ending) {
        if (next.values.beginning && next.values.ending) {
          await this.updateDays(next.values.beginning, next.values.ending, formik);
        }
      }
      if (current.values.beginning !== next.values.beginning || current.values.days !== next.values.days) {
        if (next.values.beginning && next.values.days) {
          await this.updateEnd(next.values.beginning, next.values.days, formik);
        }
      }
    }
  }

  render() {
    const { onSubmit, onClose, isOpen } = this.props;

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
              <ServiceModalForm serviceDateRangeChangeHandler={this.handleServiceDateRangeChange}/>
            </ModalBody>
            <ModalFooter>
              <Button color="primary" onClick={formikProps.submitForm}>
                Daten speichern
              </Button>
              {this.props.mainStore!.isAdmin() && (
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
