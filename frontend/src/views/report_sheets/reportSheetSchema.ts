import * as yup from 'yup';
import { apiDate } from '../../utilities/validationHelpers';
import moment from 'moment';
import { ReportSheet } from '../../types';

const errorMsg = 'Das Total der Tage muss gleich der Spesenblattdauer sein.';

export const reportSheetSchema = yup.object({
  additional_workfree: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  additional_workfree_comment: yup.string().nullable(true),
  bank_account_number: yup.string().required(),
  clothes: yup.number().required(),
  clothes_comment: yup.string().nullable(true),
  company_holiday_holiday: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  company_holiday_vacation: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  document_number: yup.number().nullable(true),
  driving_charges: yup.number().required(),
  driving_charges_comment: yup.string().nullable(true),
  end: apiDate().required(),
  extraordinarily: yup.number().required(),
  extraordinarily_comment: yup.string().nullable(true),
  holiday: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  holiday_comment: yup.string().nullable(true),
  ignore_first_last_day: yup.boolean(),
  ill: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  ill_comment: yup.string().nullable(true),
  start: apiDate().required(),
  state: yup.number().required(),
  vacation: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  vacation_comment: yup.string().nullable(true),
  work: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  workfree: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  safe_override: yup.bool(),
});

interface ReportSheetShemaWithSafeOverride extends ReportSheet {
  safe_override: boolean;
}

const validateTotal = (parent: ReportSheetShemaWithSafeOverride): boolean => {
  if (parent.safe_override) {
    return true;
  }
  const duration = moment.duration(moment(parent.end).diff(moment(parent.start))).asDays() + 1;
  let totalDays = 0;
  totalDays += parent.work + parent.workfree + parent.additional_workfree + parent.ill;
  totalDays += parent.holiday + parent.vacation;
  totalDays += parent.company_holiday_holiday + parent.company_holiday_vacation;

  return totalDays === duration;
};
