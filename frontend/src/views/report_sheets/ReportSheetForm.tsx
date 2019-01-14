import * as React from 'react';
import { ReportSheetWithProposedValues } from '../../types';
import { FormView, FormViewProps } from '../../form/FormView';
import { Field, FormikProps } from 'formik';
import Form from 'reactstrap/lib/Form';
import { CheckboxField, DatePickerField, NumberField, SelectField, TextField } from '../../form/common';
import { empty } from '../../utilities/helpers';
import { SolidHorizontalRow } from '../../layout/SolidHorizontalRow';
import Row from 'reactstrap/lib/Row';
import Col from 'reactstrap/lib/Col';
import Button from 'reactstrap/lib/Button';
import { reportSheetSchema } from './reportSheetSchema';
import { inject, observer } from 'mobx-react';
import { RouteComponentProps, withRouter } from 'react-router';
import { ReportSheetStore } from '../../stores/reportSheetStore';
import { MainStore } from '../../stores/mainStore';
import CurrencyField from '../../form/CurrencyField';

type Props = {
  mainStore?: MainStore;
  reportSheet: ReportSheetWithProposedValues;
  reportSheetStore?: ReportSheetStore;
} & FormViewProps<ReportSheetWithProposedValues> &
  RouteComponentProps;

@inject('mainStore', 'reportSheetStore')
@observer
class ReportSheetFormInner extends React.Component<Props> {
  public render() {
    const { mainStore, onSubmit, reportSheet, reportSheetStore, title } = this.props;

    return (
      <FormView
        card
        loading={empty(reportSheet) || this.props.loading}
        initialValues={reportSheet}
        onSubmit={onSubmit}
        title={title}
        validationSchema={reportSheetSchema}
        render={(formikProps: FormikProps<ReportSheetWithProposedValues>) => (
          <Form>
            <Field disabled horizontal component={TextField} name={'mission.specification.name'} label={'Pflichtenheft'} />
            <Field disabled horizontal component={DatePickerField} name={'mission.start'} label={'Beginn Einsatz'} />
            <Field disabled horizontal component={DatePickerField} name={'mission.end'} label={'Ende Einsatz'} />

            <Field horizontal component={DatePickerField} name={'start'} label={'Start Spesenblattperiode'} />
            <Field horizontal component={DatePickerField} name={'end'} label={'Ende Spesenblattperiode'} />

            <Field disabled horizontal component={NumberField} name={'mission.eligible_holiday'} label={'Ferienanspruch für Einsatz'} />
            <Field disabled horizontal component={NumberField} name={'duration'} label={'Dauer Spesenblattperiode'} />

            <SolidHorizontalRow />

            <Field
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.workdays} Tage`]}
              component={NumberField}
              name={'work'}
              label={'Gearbeitet'}
            />
            <Field
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.work_free_days} Tage`]}
              component={NumberField}
              name={'workfree'}
              label={'Arbeitsfrei'}
            />
            <Field
              horizontal
              appendedLabels={[`Übriges Guthaben: ${reportSheet.proposed_values.illness_days_left} Tage`]}
              component={NumberField}
              name={'ill'}
              label={'Krank'}
            />

            <SolidHorizontalRow />

            <Field horizontal component={NumberField} name={'additional_workfree'} label={'Zusätzlich arbeitsfrei'} />
            <Field horizontal component={TextField} name={'additional_workfree_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <Field
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.company_holidays_as_zivi_vacations} Tage`]}
              component={NumberField}
              name={'company_holiday_vacation'}
              label={'Betriebsferien (Urlaub)'}
            />
            <Field
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.company_holidays_as_zivi_holidays} Tage`]}
              component={NumberField}
              name={'company_holiday_holiday'}
              label={'Betriebsferien (Ferien)'}
            />

            <SolidHorizontalRow />

            <Field horizontal component={NumberField} name={'vacation'} label={'Ferien'} />
            <Field horizontal component={TextField} name={'vacation_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <Field horizontal component={NumberField} name={'holiday'} label={'Persönlicher Urlaub'} />
            <Field horizontal component={TextField} name={'holiday_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <Field
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.costs_clothes} CHF`]}
              component={CurrencyField}
              name={'clothes'}
              label={'Kleiderspesen'}
            />

            <SolidHorizontalRow />

            <Field horizontal component={NumberField} name={'driving_charges'} label={'Fahrspesen'} />
            <Field horizontal component={TextField} name={'driving_charges_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <Field horizontal component={NumberField} name={'extraordinarily'} label={'Ausserordentliche Spesen'} />
            <Field horizontal component={TextField} name={'extraordinarily_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <Field
              horizontal
              component={CheckboxField}
              name={'ignore_first_last_day'}
              label={'Erster / Letzter Tag nicht speziell behandeln'}
            />
            <Field disabled horizontal component={CurrencyField} name={'total_costs'} label={'Total'} />
            <Field horizontal component={TextField} name={'bank_account_number'} label={'Konto-Nr.'} />
            <Field horizontal component={NumberField} name={'document_number'} label={'Beleg-Nr.'} />
            <Field
              horizontal
              component={SelectField}
              name={'state'}
              options={[
                { id: '0', name: 'Offen' },
                { id: '1', name: 'Bereit für Auszahlung' },
                {
                  id: '2',
                  name: 'Auszahlung in Verarbeitung',
                },
                { id: '3', name: 'Erledigt' },
              ]}
              label={'Status'}
            />

            <SolidHorizontalRow />

            <Row>
              <Col md={3}>
                <Button block color={'primary'} onClick={formikProps.submitForm}>
                  Speichern
                </Button>
              </Col>

              <Col md={3}>
                <Button
                  block
                  color={'danger'}
                  onClick={async () => {
                    await reportSheetStore!.delete(reportSheet.id!);
                    this.props.history.push('/report_sheets');
                  }}
                >
                  Löschen
                </Button>
              </Col>

              <Col md={3}>
                <Button
                  block
                  color={'warning'}
                  disabled={!reportSheet.id}
                  href={mainStore!.apiURL('report_sheets/' + String(reportSheet.id!) + '/download')}
                  tag={'a'}
                  target={'_blank'}
                >
                  Drucken
                </Button>
              </Col>

              <Col md={3}>
                <Button block>Profil anzeigen (TODO)</Button>
              </Col>
            </Row>
          </Form>
        )}
      />
    );
  }
}

export const ReportSheetForm = withRouter(ReportSheetFormInner);
