import { FormikBag } from 'formik';

export interface Holiday {
  id?: number;
  beginning: string;
  ending: string;
  holiday_type: 'public_holiday' | 'company_holiday';
  description: string;
}

export enum PaymentState {
  payment_in_progress = 'payment_in_progress',
  paid = 'paid',
}

export interface Payment {
  id?: number;
  total: number;
  state: PaymentState;
  payment_timestamp: number;
  expense_sheets: PaymentExpenseSheet[];
}

export interface PaymentExpenseSheet {
  id?: number;
  total: number;
  user: {
    id: number;
    bank_iban: string;
    full_name: string;
    zdp: number;
  };
}

export interface ExpenseSheet {
  id: number;
  bank_account_number: string;
  beginning: Date;
  clothing_expenses: number;
  clothing_expenses_comment: null;
  company_holiday_comment: null;
  driving_expenses: number;
  driving_expenses_comment: null;
  duration: number;
  ending: Date;
  extraordinary_expenses: number;
  extraordinary_expenses_comment: null;
  paid_company_holiday_days: number;
  paid_vacation_comment: null;
  paid_vacation_days: number;
  payment_timestamp: null;
  sick_comment: null;
  sick_days: number;
  state: ExpenseSheetState;
  total: number;
  unpaid_company_holiday_days: number;
  unpaid_vacation_comment: null;
  unpaid_vacation_days: number;
  user_id: number;
  work_days: number;
  workfree_days: number;
  service_id: number;
}

export interface ExpenseSheetHints {
  suggestions: {
    work_days: number;
    workfree_days: number;
    paid_company_holiday_days: number;
    unpaid_company_holiday_days: number;
    clothing_expenses: number;
  };
  remaining_days: {
    sick_days: number;
    paid_vacation_days: number;
  };
}

export enum ExpenseSheetState {
  open = 'open',
  ready_for_payment = 'ready_for_payment',
  payment_in_progress = 'payment_in_progress',
  paid = 'paid',
}

export interface ShortExpenseSheetListing {
  id: number;
  ending: string;
  beginning: string;
  state: ExpenseSheetState;
  duration: number;
}

export interface ExpenseSheetListing extends ShortExpenseSheetListing {
  total: number;
  user: {
    id: number;
    address: string;
    bank_iban: string;
    city: string;
    full_name: string;
    zdp: number;
    zip: number;
  };
}

export interface DailyExpense {
  breakfast: number;
  lunch: number;
  dinner: number;
}

export interface ServiceSpecification {
  id: number;
  identification_number?: number;
  name: string;
  short_name: string;
  work_clothing_expenses: number;
  work_days_expenses: DailyExpense;
  paid_vacation_expenses: DailyExpense;
  first_day_expenses: DailyExpense;
  last_day_expenses: DailyExpense;
  accommodation_expenses: number;
  pocket_money: number;
  active: boolean;
}

export interface User {
  id: number;
  active: boolean;
  address: string;
  bank_iban: string;
  birthday: string;
  chainsaw_workshop: boolean;
  city: string;
  driving_licence_b: boolean;
  driving_licence_be: boolean;
  email: string;
  ending: null | string;
  first_name: string;
  health_insurance: string;
  hometown: string;
  internal_note: string;
  last_name: string;
  phone: string;
  regional_center_id: number;
  expense_sheets: ShortExpenseSheetListing[];
  role: 'admin' | 'civil_servant';
  services: Service[];
  beginning: null | string;
  work_experience: null | string;
  zdp: number;
  zip: number | null;
}

export interface RegionalCenter {
  name: string;
  address: string;
  short_name: string;
  id: number;
}

export interface UserFilter {
  zdp: string;
  name: string;
  beginning: string;
  ending: string;
  active: boolean;
  role: string;
}

export interface Service {
  id?: number;
  beginning: Date | null;
  service_days: number;
  confirmation_date: null | string;
  eligible_paid_vacation_days: number;
  ending: Date | null;
  first_swo_service: boolean;
  long_service: boolean;
  service_type: string | null;
  probation_period: boolean;
  service_specification_id: number;
  service_specification: {
    identification_number: number;
    name: string | undefined;
    short_name: string | undefined;
  };
  user_id: number;
}

export interface ServiceCollection {
  id?: number;
  beginning: string | null;
  ending: string | null;
  confirmation_date: string | null;
  service_specification: {
    identification_number: number;
    name: string | undefined;
    short_name: string | undefined;
  };
  user: {
    id: number;
    first_name: string | null;
    last_name: string | null;
    zdp: number;
  };
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
