import moment, { Moment } from 'moment';

type MaskFunction = (value: any) => any; //tslint:disable-line:no-any ; Couldn't find any sensible type definitions for this

// these methods are in a store so they can be adjusted depending on the users setting in the future
export class Formatter {
  public get userDateFormat(): { format: string; mask: MaskFunction } {
    return {
      format: 'DD.MM.YYYY',
      mask: value => (value ? [/\d/, /\d/, '.', /\d/, /\d/, '.', /\d/, /\d/, /\d/, /\d/] : []),
    };
  }

  public formatDate = (date: string | Moment) => {
    const o = moment(date);
    return o.format(this.userDateFormat.format);
  };

  public formatDuration = (seconds: number, unit: 'h' | 'd' = 'h', showUnit = false) => {
    const renderedUnit = showUnit ? ' ' + unit : '';
    switch (unit) {
      case 'h':
        return Number(seconds / 60).toFixed(1) + renderedUnit;
      case 'd':
        return Number((seconds / 60) * 60).toFixed(1) + renderedUnit;
    }
  };

  public formatCurrency = (amount: number | string | undefined, showUnit = true) =>
    isNaN(Number(amount)) ? '0 CHF' : (Number(amount) / 100).toFixed(2) + (showUnit ? ' CHF' : '');

  public trimString = (str: string) => {
    if (str.length > 150) {
      return str.substring(0, 150) + ' ...';
    } else {
      return str;
    }
  };
}
