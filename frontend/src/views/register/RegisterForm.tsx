import { Formik, FormikActions } from 'formik';
import * as React from 'react';
import { RouteComponentProps } from 'react-router';
import * as yup from 'yup';
import { withFormPersistence } from '../../utilities/PersistedForm';
import { withPage } from './PagedForm';
import { RegisterFormInner } from './RegisterFormInner';

const emptyMessage = (field: string) => `${field} ist leer`;

const registerSchema = yup.object({
  zdp: yup.number().required(emptyMessage('ZDP')),
  regional_center_id: yup.number().required(emptyMessage('Regionalzentrum')),
  first_name: yup.string().required(emptyMessage('Vorname')),
  last_name: yup.string().required(emptyMessage('Nachname')),
  email: yup
    .string()
    .email()
    .required(emptyMessage('Email')),
  password: yup
    .string()
    .required(emptyMessage('Passwort'))
    .min(6, 'Passwort muss mindestens 6 Zeichen sein'),
  password_confirm: yup
    .string()
    .required(emptyMessage('Passwort wiederholung'))
    .test('passwords-match', 'Passwörter müssen übereinstimmen', function(value) {
      return this.parent.password === value;
    }),
  community_password: yup.string().required(emptyMessage('Community passwort')),
  address: yup.string().required(emptyMessage('Addresse')),
  bank_iban: yup.string().required(emptyMessage('IBAN')),
  birthday: yup.date().required(emptyMessage('Geburtstag')),
  city: yup.string().required(emptyMessage('Stadt')),
  zip: yup.number().required(emptyMessage('Postleitzahl')),
  hometown: yup.string().required(emptyMessage('Heimatort')),
  phone: yup.string().required(emptyMessage('Telefon')),
  health_insurance: yup.string().required(emptyMessage('Krankenkasse')),
});

const template = {
  zdp: '',
  regional_center_id: 1,
  first_name: '',
  last_name: '',
  email: '',
  address: '',
  bank_iban: '',
  birthday: '',
  city: '',
  zip: '',
  hometown: '',
  phone: '',
  health_insurance: '',
  password: '',
  password_confirm: '',
  community_password: '',
  newsletter: true,
};

export type FormValues = typeof template;

interface RegisterFormProps extends RouteComponentProps<{ page?: string | undefined }> {
  onSubmit: (values: FormValues, formikActions: FormikActions<FormValues>) => void;
}

export const RegisterForm = ({ onSubmit, match }: RegisterFormProps) => {
  const componentOnPage = withPage(RegisterFormInner);
  const currentPage = parseInt(match.params.page!, 10) || 1;
  return (
    <Formik
      onSubmit={onSubmit}
      initialValues={template}
      validationSchema={registerSchema}
      render={withFormPersistence(RegisterForm.SESSION_STORAGE_FORM_PERSISTENCE_KEY)(componentOnPage(currentPage))}
    />
  );
};

RegisterForm.SESSION_STORAGE_FORM_PERSISTENCE_KEY = 'register-form';
