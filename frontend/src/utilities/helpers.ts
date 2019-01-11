// tslint:disable-next-line:no-any
export const empty = (value: any) => {
  if (!value) {
    return true;
  }
  return value.length === 0;
};

export { default as buildURL } from 'axios/lib/helpers/buildURL';
