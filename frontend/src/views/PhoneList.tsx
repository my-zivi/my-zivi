import { Formik, FormikActions } from 'formik';
import { inject, observer } from 'mobx-react';
import moment from 'moment';
import * as React from 'react';
import { RouteComponentProps } from 'react-router';
import Button from 'reactstrap/lib/Button';
import Col from 'reactstrap/lib/Col';
import Form from 'reactstrap/lib/Form';
import Row from 'reactstrap/lib/Row';
import * as yup from 'yup';
import { DatePickerField } from '../form/DatePickerField';
import { WiredField } from '../form/formik';
import IziviContent from '../layout/IziviContent';
import { ApiStore, baseUrl } from '../stores/apiStore';
import { MainStore } from '../stores/mainStore';
import { apiDate } from '../utilities/validationHelpers';

const phonelistSchema = yup.object({
  date_from: apiDate().required(),
  date_to: apiDate().required(),
});

interface PhoneList {
  date_from: string;
  date_to: string;
}

interface Props extends RouteComponentProps {
  apiStore?: ApiStore;
  mainStore?: MainStore;
}

@inject('apiStore', 'mainStore')
@observer
export class PhoneListView extends React.Component<Props> {
  handleSubmit = async (entity: PhoneList, actions: FormikActions<PhoneList>) => {
    const base = baseUrl;
    const inputs = phonelistSchema.cast(entity);
    const secret = this.props.apiStore!.token;

    const url = `${base}documents/phone_list?start=${inputs.date_from}&end=${inputs.date_to}&token=${secret}`;

    const win = window.open(url, '_blank');
    if (win) {
      actions.setSubmitting(false);
      win.focus();
    }
  }

  render() {
    return (
      <IziviContent card title="Telefonliste">
        <p>
          Geben Sie ein Anfangsdatum und ein Enddatum ein um eine Telefonliste mit allen Zivis zu erhalten, die in diesem Zeitraum arbeiten.
        </p>
        <br />
        <Formik
          validationSchema={phonelistSchema}
          initialValues={{
            date_from: moment()
              .date(0)
              .format('Y-MM-DD'),
            date_to: moment()
              .endOf('month')
              .format('Y-MM-DD'),
            holiday_type: 2,
            description: '',
          }}
          onSubmit={this.handleSubmit}
          render={formikProps => (
            <Form>
              <Row>
                <Col xs="12">
                  <WiredField horizontal component={DatePickerField} label={'Anfang'} name={'date_from'} />
                  <WiredField horizontal component={DatePickerField} label={'Ende'} name={'date_to'} />
                </Col>
              </Row>
              <Row>
                <Col xs={{ size: 2, offset: 10 }}>
                  <Button color={'success'} onClick={formikProps.submitForm} style={{ width: '100%' }}>
                    Laden
                  </Button>
                </Col>
              </Row>
            </Form>
          )}
        />
      </IziviContent>
    );
  }
}
