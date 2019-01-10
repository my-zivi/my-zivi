// tslint:disable-next-line:no-any
export const empty = (value: any) => {
  if (!value) {
    return true;
  }
  return value.length === 0;
};
