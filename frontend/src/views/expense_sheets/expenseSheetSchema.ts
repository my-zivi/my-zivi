import moment from 'moment';
import * as yup from 'yup';
import { ExpenseSheet, ExpenseSheetState } from '../../types';
import { apiDate } from '../../utilities/validationHelpers';

const errorMsg = 'Das Total der Tage muss gleich der Spesenblattdauer sein.';

export const expenseSheetSchema = yup.object({
  bank_account_number: yup.string().required(),
  clothing_expenses: yup.number().required(),
  clothing_expenses_comment: yup.string().nullable(true),
  unpaid_company_holiday_days: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  paid_company_holiday_days: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  company_holiday_comment: yup.string().nullable(true),
  driving_expenses: yup.number().required(),
  driving_expenses_comment: yup.string().nullable(true),
  ending: apiDate().required(),
  extraordinary_expenses: yup.number().required(),
  extraordinary_expenses_comment: yup.string().nullable(true),
  unpaid_vacation_days: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  unpaid_vacation_comment: yup.string().nullable(true),
  ignore_first_last_day: yup.boolean(),
  sick_days: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  sick_comment: yup.string().nullable(true),
  beginning: apiDate().required(),
  state: yup.string().required().oneOf(Object.values(ExpenseSheetState)),
  paid_vacation_days: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  paid_vacation_comment: yup.string().nullable(true),
  work_days: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  workfree_days: yup
    .number()
    .required()
    .test('test-total-days', errorMsg, function() {
      return validateTotal(this.parent);
    }),
  safe_override: yup.bool(),
});

interface ExpenseSheetSchemaWithSafeOverride extends ExpenseSheet {
  safe_override: boolean;
}

const validateTotal = (parent: ExpenseSheetSchemaWithSafeOverride) => {
  if (parent.safe_override) {
    return true;
  }
  const duration = moment.duration(moment(parent.ending).diff(moment(parent.beginning))).asDays() + 1;
  let totalDays = 0;
  totalDays += parent.work_days + parent.workfree_days + parent.sick_days;
  totalDays += parent.unpaid_vacation_days + parent.paid_vacation_days;
  totalDays += parent.unpaid_company_holiday_days + parent.paid_company_holiday_days;

  return totalDays === duration;
};
