import { FormikProps } from 'formik';
import { inject, observer } from 'mobx-react';
import * as React from 'react';
import { RouteComponentProps, withRouter } from 'react-router';
import Button from 'reactstrap/lib/Button';
import Col from 'reactstrap/lib/Col';
import Form from 'reactstrap/lib/Form';
import Row from 'reactstrap/lib/Row';
import { CheckboxField } from '../../form/CheckboxField';
import { NumberField, SelectField, TextField } from '../../form/common';
import CurrencyField from '../../form/CurrencyField';
import { DatePickerField } from '../../form/DatePickerField';
import { WiredField } from '../../form/formik';
import { FormView, FormViewProps } from '../../form/FormView';
import { SolidHorizontalRow } from '../../layout/SolidHorizontalRow';
import { MainStore } from '../../stores/mainStore';
import { ReportSheetStore } from '../../stores/reportSheetStore';
import { FormValues, ReportSheetWithProposedValues } from '../../types';
import { empty } from '../../utilities/helpers';
import { reportSheetSchema } from './reportSheetSchema';

type Props = {
  mainStore?: MainStore;
  reportSheet: ReportSheetWithProposedValues;
  reportSheetStore?: ReportSheetStore;
} & FormViewProps<ReportSheetWithProposedValues> &
  RouteComponentProps;

interface ReportSheetFormState {
  safeOverride: boolean;
}

@inject('mainStore', 'reportSheetStore')
@observer
class ReportSheetFormInner extends React.Component<Props, ReportSheetFormState> {
  constructor(props: Props) {
    super(props);
    this.state = {
      safeOverride: false,
    };
  }

  render() {
    const { mainStore, onSubmit, reportSheet, reportSheetStore, title } = this.props;

    const template = {
      safe_override: false,
      ...reportSheet,
    };

    return (
      <FormView
        card
        loading={empty(reportSheet) || this.props.loading}
        initialValues={template}
        onSubmit={(fv: FormValues) => {
          const rs: ReportSheetWithProposedValues = {
            ...fv,
          };
          return onSubmit(rs);
        }}
        title={title}
        validationSchema={reportSheetSchema}
        render={(formikProps: FormikProps<{}>): React.ReactNode => (
          <Form>
            <WiredField disabled horizontal component={TextField} name={'mission.specification.name'} label={'Pflichtenheft'} />
            <WiredField disabled horizontal component={DatePickerField} name={'mission.start'} label={'Beginn Einsatz'} />
            <WiredField disabled horizontal component={DatePickerField} name={'mission.end'} label={'Ende Einsatz'} />

            <WiredField horizontal component={DatePickerField} name={'start'} label={'Start Spesenblattperiode'} />
            <WiredField horizontal component={DatePickerField} name={'end'} label={'Ende Spesenblattperiode'} />

            <WiredField
              disabled
              horizontal
              component={NumberField}
              name={'mission.eligible_holiday'}
              label={'Ferienanspruch für Einsatz'}
            />
            <WiredField disabled horizontal component={NumberField} name={'duration'} label={'Dauer Spesenblattperiode'} />

            <SolidHorizontalRow />

            <WiredField
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.workdays} Tage`]}
              component={NumberField}
              name={'work'}
              label={'Gearbeitet'}
            />
            <WiredField
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.work_free_days} Tage`]}
              component={NumberField}
              name={'workfree'}
              label={'Arbeitsfrei'}
            />
            <WiredField
              horizontal
              appendedLabels={[`Übriges Guthaben: ${reportSheet.proposed_values.illness_days_left} Tage`]}
              component={NumberField}
              name={'ill'}
              label={'Krank'}
            />

            <SolidHorizontalRow />

            <WiredField horizontal component={NumberField} name={'additional_workfree'} label={'Zusätzlich arbeitsfrei'} />
            <WiredField horizontal component={TextField} name={'additional_workfree_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <WiredField
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.company_holidays_as_zivi_vacations} Tage`]}
              component={NumberField}
              name={'company_holiday_vacation'}
              label={'Betriebsferien (Urlaub)'}
            />
            <WiredField
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.company_holidays_as_zivi_holidays} Tage`]}
              component={NumberField}
              name={'company_holiday_holiday'}
              label={'Betriebsferien (Ferien)'}
            />

            <SolidHorizontalRow />

            <WiredField horizontal component={NumberField} name={'vacation'} label={'Ferien'} />
            <WiredField horizontal component={TextField} name={'vacation_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <WiredField horizontal component={NumberField} name={'holiday'} label={'Persönlicher Urlaub'} />
            <WiredField horizontal component={TextField} name={'holiday_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <WiredField
              horizontal
              appendedLabels={[`Vorschlag: ${reportSheet.proposed_values.costs_clothes} CHF`]}
              component={CurrencyField}
              name={'clothes'}
              label={'Kleiderspesen'}
            />

            <SolidHorizontalRow />

            <WiredField horizontal component={NumberField} name={'driving_charges'} label={'Fahrspesen'} />
            <WiredField horizontal component={TextField} name={'driving_charges_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <WiredField horizontal component={NumberField} name={'extraordinarily'} label={'Ausserordentliche Spesen'} />
            <WiredField horizontal component={TextField} name={'extraordinarily_comment'} label={'Bemerkung'} />

            <SolidHorizontalRow />

            <WiredField
              horizontal
              component={CheckboxField}
              name={'ignore_first_last_day'}
              label={'Erster / Letzter Tag nicht speziell behandeln'}
            />
            <WiredField disabled horizontal component={CurrencyField} name={'total_costs'} label={'Total'} />
            <WiredField horizontal component={TextField} name={'bank_account_number'} label={'Konto-Nr.'} />
            <WiredField horizontal component={NumberField} name={'document_number'} label={'Beleg-Nr.'} />
            <WiredField
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
              {this.state.safeOverride ? (
                <Col md={3}>
                  <Button
                    block
                    color={'primary'}
                    onClick={() => {
                      formikProps.setFieldValue('safe_override', true);
                      formikProps.validateForm().then(() => {
                        formikProps.submitForm();
                      });
                    }}
                  >
                    Speichern erzwingen
                  </Button>
                </Col>
              ) : (
                <Col md={3}>
                  <Button
                    block
                    color={'primary'}
                    onClick={() => {
                      formikProps.submitForm();
                      if (!formikProps.isValid) {
                        this.setState({ safeOverride: true });
                      }
                    }}
                  >
                    Speichern
                  </Button>
                </Col>
              )}

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
