import * as yup from 'yup';
import { apiDate } from '../../utilities/validationHelpers';

export const reportSheetSchema = yup.object({
  additional_workfree: yup.number().required(),
  additional_workfree_comment: yup.string().nullable(true),
  bank_account_number: yup.string().required(),
  clothes: yup.number().required(),
  clothes_comment: yup.string().nullable(true),
  company_holiday_holiday: yup.number().required(),
  company_holiday_vacation: yup.number().required(),
  document_number: yup.number().nullable(true),
  driving_charges: yup.number().required(),
  driving_charges_comment: yup.string().nullable(true),
  end: apiDate().required(),
  extraordinarily: yup.number().required(),
  extraordinarily_comment: yup.string().nullable(true),
  holiday: yup.number().required(),
  holiday_comment: yup.string().nullable(true),
  ignore_first_last_day: yup.boolean(),
  ill: yup.number().required(),
  ill_comment: yup.string().nullable(true),
  start: apiDate().required(),
  state: yup.number().required(),
  vacation: yup.number().required(),
  vacation_comment: yup.string().nullable(true),
  work: yup.number().required(),
  workfree: yup.number().required(),
});
