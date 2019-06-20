import { FormikBag } from 'formik';

export interface Holiday {
  id?: number;
  date_from: string;
  date_to: string;
  holiday_type_id: number;
  description: string;
}

export interface Payment {
  id?: number;
  amount: number;
  created_at: string;
  payment_entries: PaymentEntry[];
}

export interface PaymentEntry {
  id?: number;
  report_sheet: ReportSheet;
  user: User;
}
export interface ProposedReportSheetValues {
  company_holidays_as_zivi_holidays: number;
  company_holidays_as_zivi_vacations: number;
  costs_clothes: number;
  holidays_left: number;
  illness_days_left: number;
  work_free_days: number;
  workdays: number;
}

export interface ReportSheet {
  id?: number;
  additional_workfree: number;
  additional_workfree_comment: string;
  bank_account_number: string;
  clothes: number;
  company_holiday_holiday: number;
  company_holiday_vacation: number;
  driving_charges: number;
  driving_charges_comment: string;
  extraordinarily: number;
  extraordinarily_comment: string;
  end: string;
  holiday: number;
  holiday_comment: string;
  ignore_first_last_day: boolean;
  ill: number;
  service?: Service;
  start: string;
  state: number;
  total_costs?: number;
  user?: User;
  vacation: number;
  vacation_comment: string;
  work: number;
  workfree: number;
}

export interface ReportSheetWithProposedValues extends ReportSheet {
  proposed_values: ProposedReportSheetValues;
}

export interface ReportSheetListing {
  id: number;
  end: string;
  start: string;
  state: number;
  user_id?: number;
  user: User;
}

export interface Specification {
  id?: string;
  name: string;
  short_name: string;
  working_clothes_payment: null | string;
  working_clothes_expense: number;
  working_breakfast_expenses: number;
  working_lunch_expenses: number;
  working_dinner_expenses: number;
  sparetime_breakfast_expenses: number;
  sparetime_lunch_expenses: number;
  sparetime_dinner_expenses: number;
  firstday_breakfast_expenses: number;
  firstday_lunch_expenses: number;
  firstday_dinner_expenses: number;
  lastday_breakfast_expenses: number;
  lastday_lunch_expenses: number;
  lastday_dinner_expenses: number;
  working_time_model: number;
  working_time_weekly: string;
  accommodation: number;
  pocket: number;
  active: boolean;
}

export interface User {
  id: number;
  active: boolean;
  address: string;
  bank_bic: string;
  bank_iban: string;
  birthday: string;
  chainsaw_workshop: boolean;
  city: string;
  driving_licence_b: boolean;
  driving_licence_be: boolean;
  email: string;
  end: null | string;
  first_name: string;
  health_insurance: string;
  hometown: string;
  internal_note: string;
  last_name: string;
  services: Service[];
  phone: string;
  phone_business: string;
  phone_mobile: string;
  phone_private: string;
  regional_center_id: number;
  report_sheets: ReportSheet[];
  role: Role;
  start: null | string;
  work_experience: null | string;
  zdp: number;
  zip: number | null;
}

export interface UserFilter {
  zdp: string;
  name: string;
  date_from: string;
  date_to: string;
  active: boolean;
  role: string;
}

export interface Service {
  id?: number;
  beginning: string | null;
  days: number;
  confirmation_date: null | string;
  eligible_holiday: number;
  ending: string | null;
  feedback_done: boolean;
  feedback_mail_sent: boolean;
  first_swo_service: boolean;
  long_service: boolean;
  service_type: number | null;
  probation_period: boolean;
  specification?: Specification;
  specification_id: string;
  user_id: number;
}

export interface Role {
  id: number;
  name: UserRoleName;
}

export interface UserFeedback {
  id?: number;
}

export interface UserQuestionWithAnswers {
  id?: number;
  answers: UserQuestionAnswers;
  custom_info: string;
  opt1: string;
  opt2: string;
  question: string;
  type: number;
}

export interface UserQuestionAnswers {
  1: number;
  2: number;
  3: number;
  4: number;
  5: number;
  6: number;
}

export enum UserRoleName {
  Admin = 'admin',
  Zivi = 'civil_servant',
}

export interface Listing {
  id?: number;
  archived?: boolean;
}

export interface Column<T> {
  id: string;
  numeric?: boolean;
  label: string;
  format?: (t: T) => React.ReactNode;
  span?: {
    col?: number;
    row?: number;
  };
}

export type ActionButtonAction = (() => void) | string;

// tslint:disable-next-line:no-any ; really don't care for that type, and it comes from deep inside Formik
export type HandleFormikSubmit<Values> = (values: Values, formikBag: FormikBag<any, Values>) => void;

// If we'd type thoroughly we'd need to create a type for each models representation in a form / yup validation schema
// tslint:disable-next-line:no-any
export type FormValues = any;
