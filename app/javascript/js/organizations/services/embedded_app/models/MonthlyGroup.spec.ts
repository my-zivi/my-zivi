import moment from 'moment';
import { Service } from '../types';
import MonthlyGroup from './MonthlyGroup';

describe('MonthlyGroup', () => {
  const services: Array<Service> = [
    {
      civilServant: { fullName: 'Max Muster' },
      beginning: '2020-01-01',
      ending: '2020-03-01',
    },
  ];
  const monthlyGroup = new MonthlyGroup(moment('2020-02-03'), services);

  beforeAll(() => moment.locale('de'));

  describe('#monthName', () => {
    it('returns the correct name', () => {
      expect(monthlyGroup.monthName).toBe('Februar');
    });
  });

  describe('#monthBeginning', () => {
    it('returns the correct beginning of the month', () => {
      expect(monthlyGroup.monthBeginning.isSame(moment('2020-02-01'), 'month')).toEqual(true);
    });
  });

  describe('#monthEnd', () => {
    it('returns the correct end of the month', () => {
      expect(monthlyGroup.monthEnd.isSame(moment('2020-02-29'), 'month')).toEqual(true);
    });
  });
});
