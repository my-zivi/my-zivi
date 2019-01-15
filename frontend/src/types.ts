import { FormikBag } from 'formik';

export interface Holiday {
  id?: number;
  date_from: string;
  date_to: string;
  holiday_type_id: number;
  description: string;
}

export interface Mission {
  id?: number;
  duration: number;
  eligible_holiday: number;
  end: string;
  specification: Specification;
  start: string;
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
  driving_charges: number;
  driving_charges_comment: string;
  extraordinarily: number;
  extraordinarily_comment: string;
  end: string;
  holiday: number;
  holiday_comment: string;
  ignore_first_last_day: boolean;
  ill: number;
  mission: Mission;
  start: string;
  state: number;
  total_costs: number;
  user: User;
  vacation: number;
  vacation_comment: string;
  work: number;
  workfree: number;
}

export interface ReportSheetWithProposedValues extends ReportSheet {
  proposed_values: ProposedReportSheetValues;
}

export interface Specification {
  id?: number;
  name: string;
}

export interface User {
  id?: number;
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
  start: string;
  end: string;
  draft: null | string;
  days: number;
  eligible_holiday: number;
  mission_type: number | null;
  first_time: boolean;
  long_mission: number;
  probation_period: number;
  feedback_mail_sent: number;
  feedback_done: number;
}

export interface Role {
  id: number;
  name: UserRoleName;
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
}

export type ActionButtonAction = (() => void) | string;

//tslint:disable-next-line:no-any ; really don't care for that type, and it comes from deep inside Formik
export type HandleFormikSubmit<Values> = (values: Values, formikBag: FormikBag<any, Values>) => void;

//tslint:disable-next-line:no-any ; If we'd type thoroughly we'd need to create a type for each models representation in a form / yup validation schema
export type FormValues = any;
