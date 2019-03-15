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
  bank_bic: yup.string().required(),
  health_insurance: yup.string().required(),
});

export const missionSchema = yup.object({
  specification_id: yup.string(),
  mission_type: yup.number(),
  start: apiDate().required(),
  end: apiDate().required(),
  days: yup.number().required(),
  first_time: yup.boolean(),
  long_mission: yup.boolean(),
  probation_period: yup.boolean(),
  draft: yup.string().nullable(true),
  eligible_holiday: yup.number(),
  feedback_done: yup.boolean(),
  feedback_mail_sent: yup.boolean(),
  user_id: yup.number().required(),
});
