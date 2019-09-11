import { FormikActions, FormikProps } from 'formik';
import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { RouteComponentProps, withRouter } from 'react-router';
import Form from 'reactstrap/lib/Form';
import { FormView, FormViewProps } from '../../../form/FormView';
import { ExpenseSheetStore } from '../../../stores/expenseSheetStore';
import { MainStore } from '../../../stores/mainStore';
import { ExpenseSheet, ExpenseSheetHints, FormValues, Service, ServiceSpecification } from '../../../types';
import { empty } from '../../../utilities/helpers';
import { expenseSheetSchema } from '../expenseSheetSchema';
import { ExpenseSheetFormButtons } from './ExpenseSheetFormButtons';
import { ExpenseSheetFormHeader } from './ExpenseSheetFormHeader';
import * as FormSegments from './segments';

type Props = {
  mainStore?: MainStore;
  expenseSheet: ExpenseSheet;
  hints: ExpenseSheetHints;
  service: Service;
  expenseSheetStore?: ExpenseSheetStore;
  serviceSpecification: ServiceSpecification;
} & FormViewProps<ExpenseSheet> &
  RouteComponentProps;

interface ExpenseSheetFormState {
  safeOverride: boolean;
}

@inject('mainStore', 'expenseSheetStore', 'serviceSpecificationStore')
@observer
class ExpenseSheetFormInner extends React.Component<Props, ExpenseSheetFormState> {
  constructor(props: Props) {
    super(props);
    this.state = {
      safeOverride: false,
    };

  }

  render() {
    const { loading, mainStore, onSubmit, expenseSheet, service, serviceSpecification, hints, title, expenseSheetStore } = this.props;

    const template = {
      safe_override: false,
      ...expenseSheet,
    };

    return (!empty(expenseSheet) && !this.props.loading) && (
      <FormView<ExpenseSheet>
        card
        loading={empty(expenseSheet) || this.props.loading}
        initialValues={template}
        onSubmit={(formValues: FormValues) => onSubmit({ ...formValues })}
        title={title}
        validationSchema={expenseSheetSchema}
        render={(formikProps: FormikProps<{}>): React.ReactNode => (
          <Form>
            <ExpenseSheetFormHeader
              service={service}
              expenseSheetState={expenseSheet.state}
              serviceSpecification={serviceSpecification}
            />

            <FormSegments.GeneralSegment service={service}/>
            <FormSegments.AbsolvedDaysBreakdownSegment hints={hints}/>
            <FormSegments.CompanyHolidaysSegment hints={hints}/>
            <FormSegments.PaidVacationSegment/>
            <FormSegments.UnpaidVacationSegment/>
            <FormSegments.ClothingExpensesSegment hints={hints} mainStore={mainStore!}/>
            <FormSegments.DrivingExpensesSegment/>
            <FormSegments.ExtraordinaryExpensesSegment/>
            <FormSegments.FooterSegment/>
            <FormSegments.StateSegment expenseSheetState={expenseSheet.state} expenseSheetStore={expenseSheetStore!}/>

            <ExpenseSheetFormButtons
              safeOverride={this.state.safeOverride}
              onForceSave={() => this.onForceSaveButtonClicked(formikProps)}
              onSave={() => this.onSaveButtonClicked(formikProps)}
              onDelete={this.onDeleteButtonClicked.bind(this)}
              expenseSheet={expenseSheet}
              mainStore={mainStore!}
              service={service}
            />
          </Form>
        )}
      />
    );
  }

  private onForceSaveButtonClicked(formikProps: FormikProps<{}>) {
    formikProps.setFieldValue('safe_override', true);
    formikProps.validateForm().then(() => {
      formikProps.submitForm();
    });
  }

  private async onDeleteButtonClicked() {
    await this.props.expenseSheetStore!.delete(this.props.expenseSheet.id!);
    this.props.history.push(`/users/${this.props.expenseSheet.user_id}`);
  }

  private onSaveButtonClicked(formikProps: FormikProps<{}>) {
    formikProps.submitForm();
    this.setState({ safeOverride: !formikProps.isValid });
  }
}

export const ExpenseSheetForm = withRouter(ExpenseSheetFormInner);
