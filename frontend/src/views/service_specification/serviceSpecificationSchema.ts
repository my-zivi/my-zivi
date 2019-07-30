import * as yup from 'yup';

const dailyExpenseSchema = yup.object({
  breakfast: yup.number().required(),
  lunch: yup.number().required(),
  dinner: yup.number().required(),
});

const serviceSpecificationSchema = yup.object({
  identification_number: yup
    .string()
    .matches(/[0-9_]+/, 'Die ID muss aus Zahlen und Bodenstrichen bestehen.')
    .required(),
  name: yup.string().required(),
  short_name: yup.string().required(),
  work_clothing_expenses: yup.number().required(),
  work_days_expenses: dailyExpenseSchema,
  paid_vacation_expenses: dailyExpenseSchema,
  first_day_expenses: dailyExpenseSchema,
  last_day_expenses: dailyExpenseSchema,
  accommodation_expenses: yup.number().required(),
  pocket_money: yup.number().required(),
  active: yup.boolean(),
});

export default serviceSpecificationSchema;
