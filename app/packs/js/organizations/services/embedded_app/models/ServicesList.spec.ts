import moment from 'moment';
import ServiceFactory from '../../../../tests/factories/ServiceFactory';
import Factories from '../../../../tests/factories/Factories';
import ServicesList from './ServicesList';

describe('ServicesList', () => {
  moment.locale('de');

  const lateService = ServiceFactory.build({ beginning: '2020-02-07', ending: '2020-03-13' });
  const earlyServices = Factories.buildList(ServiceFactory, 2, { beginning: '2020-01-06', ending: '2020-02-07' });
  const services = [
    lateService,
    ...earlyServices,
  ];

  const servicesList = new ServicesList(services);

  describe('#constructor', () => {
    it('sorts the services', () => {
      expect(servicesList.services[2]).toEqual(lateService);
      expect(servicesList.services.slice(0, 2)).toEqual(expect.arrayContaining(earlyServices));
    });
  });

  describe('#planBeginning', () => {
    it('returns the beginning of the table', () => {
      expect(servicesList.planBeginning.isSame(moment('2020-01-01'), 'day')).toBe(true);
    });
  });

  describe('#planEnding', () => {
    it('returns the ending of the table', () => {
      expect(servicesList.planEnding.isSame(moment('2020-03-31'), 'day')).toBe(true);
    });
  });

  describe('#monthlyGroups', () => {
    it('returns the services grouped by month', () => {
      expect(servicesList.monthlyGroups.length).toBe(3);

      const [january, february, march] = servicesList.monthlyGroups;
      expect(january.monthName).toBe('Januar');
      expect(february.monthName).toBe('Februar');
      expect(march.monthName).toBe('März');
    });
  });
});
