import { Formik, FormikActions } from 'formik';
import { inject, observer } from 'mobx-react';
import moment from 'moment';
import * as React from 'react';
import { RouteComponentProps } from 'react-router';
import Button from 'reactstrap/lib/Button';
import * as yup from 'yup';
import IziviContent from '../../layout/IziviContent';
import { HolidayStore } from '../../stores/holidayStore';
import { MainStore } from '../../stores/mainStore';
import { Holiday } from '../../types';
import { apiDate } from '../../utilities/validationHelpers';
import { HolidayOverviewTable } from './HolidayOverviewTable';
import HolidayTableRow from './HolidayTableRow';

const holidaySchema = yup.object({
  beginning: apiDate().required(),
  ending: apiDate().required(),
  holiday_type: yup.string().required().matches(/company_holiday|public_holiday/),
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
  constructor(props: Props) {
    super(props);
    this.props.holidayStore!.fetchAll().then(() => this.setState({ loading: false }));

    this.state = {
      loading: true,
    };
  }

  handleSubmit = async (holiday: Holiday, actions: FormikActions<Holiday>) => {
    await this.props.holidayStore!.put(holidaySchema.cast(holiday) as Holiday);
    actions.setSubmitting(false);
  }

  handleAdd = async (holiday: Holiday, actions: FormikActions<Holiday>) => {
    await this.props.holidayStore!.post(holidaySchema.cast(holiday) as Holiday).then(() => {
      actions.setSubmitting(false);
      actions.resetForm();
    });
  }

  render() {
    const holidays = this.props.holidayStore!.entities;
    const holidayStore = this.props.holidayStore!;

    return (
      <IziviContent loading={this.state.loading} title={'Freitage'} card={true}>
        <HolidayOverviewTable mainStore={this.props.mainStore!}>
          <Formik
            validationSchema={holidaySchema}
            initialValues={{
              beginning: moment().format('Y-MM-DD'),
              ending: moment().format('Y-MM-DD'),
              holiday_type: 'company_holiday',
              description: '',
            }}
            onSubmit={this.handleAdd}
            render={({ isSubmitting, submitForm }) => (
              <HolidayTableRow
                buttons={[
                  <Button key={'submitButton'} color={'success'} disabled={isSubmitting} onClick={submitForm}>Hinzufügen</Button>,
                ]}
              />
            )}
          />
          {holidays.map(holiday => (
            <Formik
              key={holiday.id}
              validationSchema={holidaySchema}
              initialValues={holiday}
              onSubmit={this.handleSubmit}
              render={({ isSubmitting, submitForm }) => (
                <HolidayTableRow
                  buttons={[
                    (
                      <Button color={'success'} disabled={isSubmitting} onClick={submitForm}>
                        Speichern
                      </Button>
                    ),
                    (
                      <Button color={'danger'} disabled={isSubmitting} onClick={() => holidayStore!.delete(holiday.id!)}>
                        Löschen
                      </Button>
                    ),
                  ]}
                />
              )}
            />
          ))}
        </HolidayOverviewTable>
      </IziviContent>
    );
  }
}
