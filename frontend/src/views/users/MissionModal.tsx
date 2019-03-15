import Button from 'reactstrap/lib/Button';
import { Mission, User } from '../../types';
import Modal from 'reactstrap/lib/Modal';
import ModalHeader from 'reactstrap/lib/ModalHeader';
import ModalBody from 'reactstrap/lib/ModalBody';
import ModalFooter from 'reactstrap/lib/ModalFooter';
import { inject } from 'mobx-react';
import { Formik, FormikProps } from 'formik';
import Form from 'reactstrap/lib/Form';
import Alert from 'reactstrap/lib/Alert';
import { SelectField, TextField } from 'src/form/common';
import { DatePickerField } from 'src/form/DatePickerField';
import { SpecificationSelect } from 'src/form/entitiySelect/SpecificationSelect';
import Effect, { OnChange } from 'src/utilities/Effect';
import moment from 'moment';
import { apiDateFormat } from 'src/stores/apiStore';
import debounce from 'lodash.debounce';
import { CheckboxField } from 'src/form/CheckboxField';
import * as React from 'react';
import { MissionStore } from 'src/stores/missionStore';
import { WiredField } from '../../form/formik';

export interface MissionModalProps<T> {
  onSubmit: (values: T) => Promise<void>;
  user: User;
  values?: Mission;
  onClose: (e?: React.MouseEvent<HTMLButtonElement>) => void;
  isOpen: boolean;
  missionStore?: MissionStore;
}

@inject('missionStore')
export class MissionModal extends React.Component<MissionModalProps<Mission>> {
  private initialValues: Mission;
  private autoUpdate = true;
  constructor(props: MissionModalProps<Mission>) {
    super(props);
    this.initialValues = props.values
      ? props.values
      : {
          specification_id: '',
          mission_type: 0,
          start: null,
          end: null,
          days: 0,
          first_time: false,
          long_mission: false,
          probation_period: false,
          draft: null,
          eligible_holiday: 0,
          feedback_done: false,
          feedback_mail_sent: false,
          user_id: props.user.id,
        };
  }
  handleMissionDateRangeChange: OnChange<Mission> = async (current, next, formik) => {
    if (this.autoUpdate) {
      if (current.values.start !== next.values.start || current.values.end !== next.values.end) {
        if (next.values.start && next.values.end) {
          await this.updateDays(next.values.start, next.values.end, formik);
        }
      }
      if (current.values.start !== next.values.start || current.values.days !== next.values.days) {
        if (next.values.start && next.values.days) {
          await this.updateEnd(next.values.start, next.values.days, formik);
        }
      }
    }
  };
  private updateDays = debounce(async (start: string, end: string, formik: FormikProps<Mission>) => {
    this.autoUpdate = false;
    const data = await this.props.missionStore!.calcEligibleDays(moment(start).format(apiDateFormat), moment(end).format(apiDateFormat));
    if (data) {
      formik.setFieldValue('days', data);
    }
    this.autoUpdate = true;
  }, 500);
  private updateEnd = debounce(async (start: string, days: number, formik: FormikProps<Mission>) => {
    this.autoUpdate = false;
    const data = await this.props.missionStore!.calcPossibleEndDate(moment(start).format(apiDateFormat), days);
    if (data) {
      formik.setFieldValue('end', data);
    }
    this.autoUpdate = true;
  }, 500);
  render() {
    const { onSubmit, onClose, isOpen } = this.props;
    return (
      isOpen && (
        <Formik
          onSubmit={onSubmit}
          initialValues={this.initialValues}
          render={(formikProps: FormikProps<Mission>) => (
            <Modal isOpen toggle={onClose}>
              <ModalHeader toggle={onClose}>Zivildiensteinsatz</ModalHeader>
              <ModalBody>
                <Form>
                  <Alert color="info">
                    <b>Hinweis:</b> Du kannst entweder das gewünschte Enddatum für deinen Einsatz eingeben, und die anrechenbaren
                    Einsatztage werden gerechnet, oder die gewünschten Einsatztage eingeben, und das Enddatum wird berechnet. In beiden
                    Fällen musst du das Startdatum bereits eingegeben haben.
                  </Alert>
                  <WiredField horizontal component={SpecificationSelect} name={'specification_id'} label={'Pflichtenheft'} />
                  <WiredField
                    horizontal
                    component={SelectField}
                    name={'mission_type'}
                    label={'Einsatzart'}
                    options={[{ id: 0, name: '' }, { id: 1, name: 'Erster Einsatz' }, { id: 2, name: 'Letzter Einsatz' }]}
                  />
                  <Effect onChange={this.handleMissionDateRangeChange} />
                  <WiredField horizontal component={DatePickerField} name={'start'} label={'Einsatzbeginn'} />
                  <WiredField horizontal component={DatePickerField} name={'end'} label={'Einsatzende'} />
                  <WiredField horizontal component={TextField} name={'days'} label={'Einsatztage'} />
                  <WiredField horizontal component={CheckboxField} name={'first_time'} label={'Erster SWO Einsatz?'} />
                  <WiredField horizontal component={CheckboxField} name={'long_mission'} label={'Langer Einsatz?'} />
                  <WiredField horizontal component={CheckboxField} name={'probation_period'} label={'Probe-einsatz?'} />
                </Form>
              </ModalBody>
              <ModalFooter>
                <Button color="primary" onClick={formikProps.submitForm}>
                  Daten speichern
                </Button>{' '}
                <Button color="secondary">Aufgebot erhalten</Button>
              </ModalFooter>
            </Modal>
          )}
        />
      )
    );
  }
}
