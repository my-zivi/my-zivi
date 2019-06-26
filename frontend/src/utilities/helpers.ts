// tslint:disable-next-line:no-any
import { User } from '../types';

export const empty = (value: any) => {
  if (!value) {
    return true;
  }
  return value.length === 0;
};

export const translateUserRole = (user: User) => {
  switch (user.role) {
    case 'admin':
      return 'Admin';
    case 'civil_servant':
      return 'Zivi';
  }
};

export { default as buildURL } from 'axios/lib/helpers/buildURL';
