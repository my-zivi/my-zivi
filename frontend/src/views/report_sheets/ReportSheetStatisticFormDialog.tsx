import { Formik } from 'formik';
import moment from 'moment';
import * as React from 'react';
import { Button, ModalHeader } from 'reactstrap';
import Modal from 'reactstrap/lib/Modal';
import ModalBody from 'reactstrap/lib/ModalBody';
import ModalFooter from 'reactstrap/lib/ModalFooter';
import { CheckboxField } from '../../form/CheckboxField';
import { SelectField } from '../../form/common';
import { DatePickerField } from '../../form/DatePickerField';
import { WiredField } from '../../form/formik';
import { MainStore } from '../../stores/mainStore';

const yearOptions = () => {
  const listOfYears = [];
  for (let i = 2005; i < moment().year() + 3; i++) {
    listOfYears.push({
      id: i,
      name: i,
    });
  }

  return listOfYears;
};

interface Props {
  isOpen: boolean;
  mainStore: MainStore;
  toggle: () => void;
}

export class ReportSheetStatisticFormDialog extends React.Component<Props> {
  render() {
    const { isOpen, mainStore, toggle } = this.props;

    return (
      <Modal isOpen={isOpen}>
        <ModalHeader>Spesenstatistik erstellen</ModalHeader>
        <Formik
          initialValues={{
            beginning: moment()
              .startOf('year')
              .format('Y-MM-DD'),
            ending: moment()
              .endOf('year')
              .format('Y-MM-DD'),
            detail_view: true,
            only_done_sheets: true,
            time_type: '0',
            year: moment().year(),
          }}
          onSubmit={() => {
            /* nothing happens here because I didn't want to write the onChange handler myself */
          }}
          render={formikProps => (
            <>
              <ModalBody>
                <WiredField
                  horizontal
                  component={SelectField}
                  name={'time_type'}
                  options={[
                    { id: '0', name: 'Gesamtes Jahr' },
                    { id: '1', name: 'Von / Bis' },
                    { id: '2', name: moment().format('MMMM YYYY') },
                    {
                      id: '3',
                      name: moment()
                        .subtract(1, 'month')
                        .format('MMMM YYYY'),
                    },
                  ]}
                  label={'Zeitspanne'}
                />

                {formikProps.values.time_type === '0' && (
                  <WiredField horizontal component={SelectField} name={'year'} options={yearOptions()} label={'Jahr'} />
                )}

                {formikProps.values.time_type === '1' && (
                  <>
                    <WiredField horizontal component={DatePickerField} name={'beginning'} label={'Start'} />
                    <WiredField horizontal component={DatePickerField} name={'ending'} label={'Ende'} />
                  </>
                )}

                <WiredField component={CheckboxField} name={'only_done_sheets'} label={'Nur erledigte Spesenblätter anzeigen?'} />

                <WiredField component={CheckboxField} name={'detail_view'} label={'Detaillierte Ansicht anzeigen?'} />
              </ModalBody>

              <ModalFooter>
                <Button href={mainStore.apiURL('documents/expenses_overview', formikProps.values)} tag={'a'} target={'_blank'}>
                  PDF generieren
                </Button>{' '}
                <Button color="danger" onClick={toggle}>
                  Abbrechen
                </Button>
              </ModalFooter>
            </>
          )}
        />
      </Modal>
    );
  }
}
