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
  mission?: Mission;
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
  first_name: string;
  last_name: string;
  start: string;
  state: number;
  zdp: number;
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
  email: string;
  role_id: number;
  zdp: number;
  first_name: string;
  last_name: string;
  address: string;
  zip: number | null;
  city: string;
  hometown: string;
  hometown_canton: number | null;
  canton: number | null;
  birthday: string;
  phone_mobile: string;
  phone_private: string;
  phone_business: string;
  bank_iban: string;
  bank_bic: string;
  health_insurance: string;
  work_experience: null | string;
  driving_licence: number | null;
  ga_travelcard: number;
  half_fare_travelcard: number;
  other_fare_network: null | string;
  regional_center_id: number;
  internal_note: string;
  phone: string;
  driving_licence_b: boolean;
  driving_licence_be: boolean;
  chainsaw_workshop: boolean;
  role: Role;
  start: null | string;
  end: null | string;
  active: boolean;
  missions: Mission[];
  report_sheets: ReportSheet[];
}

export interface UserFilter {
  zdp: string;
  name: string;
  date_from: string;
  date_to: string;
  active: boolean;
  role: string;
}

export interface Mission {
  id?: number;
  user_id: number;
  specification_id: string;
  mission_type: number | null;
  start: string | null;
  end: string | null;
  days: number;
  first_time: boolean;
  long_mission: boolean;
  probation_period: boolean;
  draft: null | string;
  eligible_holiday: number;
  feedback_mail_sent: boolean;
  feedback_done: boolean;
  user?: User;
  specification?: Specification;
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
  Zivi = 'zivi',
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
