export interface Holiday {
  id?: number;
  date_from: string;
  date_to: string;
  holiday_type_id: number;
  description: string;
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
