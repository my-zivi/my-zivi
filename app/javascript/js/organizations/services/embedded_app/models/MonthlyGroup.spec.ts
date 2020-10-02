import moment, { Moment } from 'moment';
import { range } from 'lodash';
import MonthlyGroup from './MonthlyGroup';
import { Service } from '../types';

describe('MonthlyGroup', () => {
  moment.locale('de');

  const service: Service = {
    civilServant: { fullName: 'Max Muster' },
    beginning: '2020-01-01',
    ending: '2020-03-01',
  };

  const monthlyGroup = new MonthlyGroup(moment('2020-02-03'), [service]);

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

  describe('#containsService', () => {
    it('returns true if the monthly group contains the service', () => {
      expect(monthlyGroup.containsService(service)).toBe(true);
    });

    it('returns false if the monthly group does not contain the service', () => {
      const outsideService: Service = {
        beginning: '2000-01-01',
        civilServant: { fullName: 'Peter Peterle' },
        ending: '2000-12-01',
      };

      expect(monthlyGroup.containsService(outsideService)).toBe(false);
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
