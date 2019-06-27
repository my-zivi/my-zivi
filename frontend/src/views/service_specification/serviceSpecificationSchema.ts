import * as yup from 'yup';

const serviceSpecificationSchema = yup.object({
  identification_number: yup
    .string()
    .matches(/[0-9_]+/, 'Die ID muss aus Zahlen und Bodenstrichen bestehen.')
    .required(),
  name: yup.string().required(),
  short_name: yup.string().required(),
  working_clothes_expense: yup.number().required(),
  working_breakfast_expenses: yup.number().required(),
  working_lunch_expenses: yup.number().required(),
  working_dinner_expenses: yup.number().required(),
  sparetime_breakfast_expenses: yup.number().required(),
  sparetime_lunch_expenses: yup.number().required(),
  sparetime_dinner_expenses: yup.number().required(),
  firstday_breakfast_expenses: yup.number().required(),
  firstday_lunch_expenses: yup.number().required(),
  firstday_dinner_expenses: yup.number().required(),
  lastday_breakfast_expenses: yup.number().required(),
  lastday_lunch_expenses: yup.number().required(),
  lastday_dinner_expenses: yup.number().required(),
  working_time_model: yup.number().required(),
  accommodation: yup.number().required(),
  working_clothes_payment: yup.string().nullable(),
  working_time_weekly: yup.string(),
  pocket: yup.number().required(),
  active: yup.boolean(),
});

export default serviceSpecificationSchema;
