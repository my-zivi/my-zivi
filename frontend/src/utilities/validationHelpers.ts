import * as yup from 'yup';
import moment from 'moment';
import { apiDateFormat } from '../stores/apiStore';

export const apiDate = () =>
  yup.mixed().transform(value => {
    return value ? moment(value).format(apiDateFormat) : null;
  });
