import moment, { Moment } from 'moment';
import { range } from 'lodash';
import MonthlyGroup from './MonthlyGroup';

describe('MonthlyGroup', () => {
  moment.locale('de');
  const monthlyGroup = new MonthlyGroup(moment('2020-02-03'));

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

  describe('#mapDays', () => {
    it('calls the callback for each day within the month the group spans', () => {
      const callback = jest.fn((day: Moment) => day.get('dayOfYear'));

      const mappedValues = monthlyGroup.mapDays(callback);
      expect(callback).toHaveBeenCalledTimes(29);
      expect(mappedValues).toEqual(range(32, 61));
    });
  });
});
