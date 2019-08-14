import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Formik, FormikActions } from 'formik';
import { inject } from 'mobx-react';
import * as React from 'react';
import injectSheet, { WithSheet } from 'react-jss';
import Button from 'reactstrap/lib/Button';
import IziviContent from '../../layout/IziviContent';
import { MainStore } from '../../stores/mainStore';
import { ServiceSpecificationStore } from '../../stores/serviceSpecificationStore';
import { ServiceSpecification } from '../../types';
import { PlusSquareRegularIcon, SaveRegularIcon } from '../../utilities/Icon';
import serviceSpecificationStyles from './serviceSpecificationOverviewStyle';
import serviceSpecificationSchema from './serviceSpecificationSchema';
import { ServiceSpecificationsOverviewTable } from './ServiceSpecificationsOverviewTable';
import { ServiceSpecificationOverviewTableRowFields } from './ServiceSpecificationsOverviewTableRowFields';

const INITIAL_DAILY_EXPENSES_FORM_VALUES = Object.freeze({ breakfast: 0, lunch: 0, dinner: 0 });
const INITIAL_FORM_VALUES = Object.freeze({
  identification_number: '',
  name: '',
  short_name: '',
  work_clothing_expenses: 0,
  work_days_expenses: INITIAL_DAILY_EXPENSES_FORM_VALUES,
  paid_vacation_expenses: INITIAL_DAILY_EXPENSES_FORM_VALUES,
  first_day_expenses: INITIAL_DAILY_EXPENSES_FORM_VALUES,
  last_day_expenses: INITIAL_DAILY_EXPENSES_FORM_VALUES,
  accommodation_expenses: 0,
  active: false,
  pocket_money: 500,
});

interface ServiceSpecificationProps extends WithSheet<typeof serviceSpecificationStyles> {
  serviceSpecificationStore?: ServiceSpecificationStore;
  mainStore?: MainStore;
}

interface ServiceSpecificationState {
  loading: boolean;
}

@inject('serviceSpecificationStore', 'mainStore')
export class ServiceSpecificationsOverviewInner extends React.Component<ServiceSpecificationProps, ServiceSpecificationState> {
  constructor(props: ServiceSpecificationProps) {
    super(props);

    this.props.serviceSpecificationStore!.fetchAll().then(() => {
      this.setState({ loading: false });
    });

    this.state = {
      loading: true,
    };
  }

  handleSubmit = async (entity: ServiceSpecification, actions: FormikActions<ServiceSpecification>) => {
    this.props.serviceSpecificationStore!.put(serviceSpecificationSchema.cast(entity)).then(() => actions.setSubmitting(false));
  }

  handleAdd = async (entity: ServiceSpecification, actions: FormikActions<ServiceSpecification>) => {
    await this.props.serviceSpecificationStore!.post(serviceSpecificationSchema.cast(entity)).then(() => {
      actions.setSubmitting(false);
      actions.resetForm();
    });
  }

  render() {
    const entities = this.props.serviceSpecificationStore!.entities;

    return (
      <IziviContent loading={this.state.loading} title={'Pflichtenheft'} card={true} fullscreen>
        <ServiceSpecificationsOverviewTable classes={this.props.classes} theme={this.props.theme}>
          <Formik
            validationSchema={serviceSpecificationSchema}
            initialValues={INITIAL_FORM_VALUES}
            onSubmit={this.handleAdd}
            render={formikProps => (
              <tr>
                <ServiceSpecificationOverviewTableRowFields {...this.props} />
                <td className={this.props.classes.buttonsTd}>
                  <Button
                    className={this.props.classes.smallFontSize}
                    color={'success'}
                    disabled={formikProps.isSubmitting}
                    onClick={formikProps.submitForm}
                  >
                    <FontAwesomeIcon icon={PlusSquareRegularIcon} />
                  </Button>
                </td>
                <td />
              </tr>
            )}
          />
          {entities.map(serviceSpecification => (
            <Formik
              key={serviceSpecification.identification_number}
              validationSchema={serviceSpecificationSchema}
              initialValues={serviceSpecification}
              onSubmit={this.handleSubmit}
              render={formikProps => (
                <tr>
                  <ServiceSpecificationOverviewTableRowFields {...this.props} />
                  <td className={this.props.classes.buttonsTd}>
                    <Button
                      className={this.props.classes.smallFontSize}
                      color={'success'}
                      disabled={formikProps.isSubmitting}
                      onClick={formikProps.submitForm}
                    >
                      <FontAwesomeIcon icon={SaveRegularIcon} />
                    </Button>
                  </td>
                </tr>
              )}
            />
          ))}
        </ServiceSpecificationsOverviewTable>
      </IziviContent>
    );
  }
}

export const ServiceSpecificationsOverview = injectSheet(serviceSpecificationStyles)(ServiceSpecificationsOverviewInner);
