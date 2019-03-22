import { Formik, FormikActions } from 'formik';
import { inject, observer } from 'mobx-react';
import moment from 'moment';
import * as React from 'react';
import { RouteComponentProps } from 'react-router';
import Button from 'reactstrap/lib/Button';
import Table from 'reactstrap/lib/Table';
import * as yup from 'yup';
import { SelectField, TextField } from '../form/common';
import { DatePickerField } from '../form/DatePickerField';
import { WiredField } from '../form/formik';
import IziviContent from '../layout/IziviContent';
import { HolidayStore } from '../stores/holidayStore';
import { MainStore } from '../stores/mainStore';
import { Column, Holiday } from '../types';
import { apiDate } from '../utilities/validationHelpers';

const holidaySchema = yup.object({
  date_from: apiDate().required(),
  date_to: apiDate().required(),
  holiday_type_id: yup.number().required(),
  description: yup.string().required(),
});

interface Props extends RouteComponentProps {
  holidayStore?: HolidayStore;
  mainStore?: MainStore;
}

interface State {
  loading: boolean;
}

@inject('holidayStore', 'mainStore')
@observer
export class HolidayOverview extends React.Component<Props, State> {
  columns: Array<Column<Holiday>> = [];

  constructor(props: Props) {
    super(props);
    this.props.holidayStore!.fetchAll().then(() => {
      this.setState({ loading: false });
    });

    this.state = {
      loading: true,
    };

    this.columns = [
      {
        id: 'date_from',
        numeric: false,
        label: 'Datum Start',
        format: h => this.props.mainStore!.formatDate(h.date_from),
      },
      {
        id: 'date_to',
        numeric: false,
        label: 'Datum Ende',
        format: h => this.props.mainStore!.formatDate(h.date_to),
      },
      {
        id: 'holiday_type_id',
        numeric: false,
        label: 'Type',
      },
      {
        id: 'description',
        numeric: false,
        label: 'Beschreibung',
      },
      {
        id: 'save',
        numeric: false,
        label: '',
      },
      {
        id: 'delete',
        numeric: false,
        label: '',
      },
    ];
  }

  handleSubmit = async (entity: Holiday, actions: FormikActions<Holiday>) => {
    this.props.holidayStore!.put(holidaySchema.cast(entity)).then(() => actions.setSubmitting(false));
  }

  handleAdd = async (entity: Holiday, actions: FormikActions<Holiday>) => {
    await this.props.holidayStore!.post(holidaySchema.cast(entity)).then(() => {
      actions.setSubmitting(false);
      actions.resetForm();
    });
  }

  render() {
    const entities = this.props.holidayStore!.entities;
    const holidayStore = this.props.holidayStore!;

    return (
      <IziviContent loading={this.state.loading} title={'Freitage'} card={true}>
        <Table>
          <thead>
            <tr>
              {this.columns.map(col => (
                <th key={col.id}>{col.label}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            <Formik
              validationSchema={holidaySchema}
              initialValues={{
                date_from: moment().format('Y-MM-DD'),
                date_to: moment().format('Y-MM-DD'),
                holiday_type_id: 2,
                description: '',
              }}
              onSubmit={this.handleAdd}
              render={formikProps => (
                <tr>
                  <td>
                    <WiredField component={DatePickerField} name={'date_from'} />
                  </td>
                  <td>
                    <WiredField component={DatePickerField} name={'date_to'} />
                  </td>
                  <td>
                    <WiredField
                      component={SelectField}
                      name={'holiday_type_id'}
                      options={[{ id: '1', name: 'Betriebsferien' }, { id: '2', name: 'Feiertag' }]}
                    />
                  </td>
                  <td>
                    <WiredField component={TextField} name={'description'} />
                  </td>
                  <td>
                    <Button color={'success'} disabled={formikProps.isSubmitting} onClick={formikProps.submitForm}>
                      Hinzufügen
                    </Button>
                  </td>
                  <td />
                </tr>
              )}
            />
            {entities.map(holiday => (
              <Formik
                key={holiday.id}
                validationSchema={holidaySchema}
                initialValues={holiday}
                onSubmit={this.handleSubmit}
                render={formikProps => (
                  <tr>
                    <td>
                      <WiredField component={DatePickerField} name={'date_from'} />
                    </td>
                    <td>
                      <WiredField component={DatePickerField} name={'date_to'} />
                    </td>
                    <td>
                      <WiredField
                        component={SelectField}
                        name={'holiday_type_id'}
                        options={[{ id: '1', name: 'Betriebsferien' }, { id: '2', name: 'Feiertag' }]}
                      />
                    </td>
                    <td>
                      <WiredField component={TextField} name={'description'} />
                    </td>
                    <td>
                      <Button color={'success'} disabled={formikProps.isSubmitting} onClick={formikProps.submitForm}>
                        Speichern
                      </Button>
                    </td>
                    <td>
                      <Button
                        color={'danger'}
                        disabled={formikProps.isSubmitting}
                        onClick={() => {
                          holidayStore!.delete(holiday.id!);
                        }}
                      >
                        Löschen
                      </Button>
                    </td>
                  </tr>
                )}
              />
            ))}
          </tbody>
        </Table>
      </IziviContent>
    );
  }
}
