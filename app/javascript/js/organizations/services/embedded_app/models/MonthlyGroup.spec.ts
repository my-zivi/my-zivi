import moment from 'moment';
import MonthlyGroup from './MonthlyGroup';

describe('MonthlyGroup', () => {
  moment.locale('de');

  const monthlyGroup = new MonthlyGroup(moment('2020-02-03'), [
    {
      civilServant: { fullName: 'Max Muster' },
      beginning: '2020-01-01',
      ending: '2020-03-01',
    },
  ]);

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
