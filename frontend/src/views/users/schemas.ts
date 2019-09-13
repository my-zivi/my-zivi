import * as yup from 'yup';
import { apiDate } from '../../utilities/validationHelpers';

export const userSchema = yup.object({
  zdp: yup.number(),
  first_name: yup.string().required(),
  last_name: yup.string().required(),
  address: yup.string().required(),
  zip: yup.number().required(),
  city: yup.string().required(),
  hometown: yup.string().required(),
  birthday: apiDate().required(),
  email: yup.string().required(),
  phone: yup.string().required(),
  bank_iban: yup.string().required(),
  health_insurance: yup.string().required(),
});

export const serviceSchema = yup.object({
  service_specification_id: yup.number().required(),
  service_specification: yup.object({
      identification_number: yup.string(),
      short_name: yup.string(),
      name: yup.string(),
  }),
  service_type: yup.string(),
  beginning: apiDate().required(),
  ending: apiDate().required(),
  service_days: yup.number().required(),
  first_swo_service: yup.boolean(),
  long_service: yup.boolean(),
  probation_period: yup.boolean(),
  confirmation_date: yup.string().nullable(true),
  eligible_paid_vacation_days: yup.number(),
  feedback_done: yup.boolean(),
  feedback_mail_sent: yup.boolean(),
  user_id: yup.number().required(),
});
