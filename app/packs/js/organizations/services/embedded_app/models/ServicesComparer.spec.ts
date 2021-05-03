import ServiceFactory from '../../../../tests/factories/ServiceFactory';
import ServicesComparer from './ServicesComparer';

describe('ServicesComparer', () => {
  describe('compare', () => {
    describe('if first service begins earlier than second service', () => {
      const service1 = ServiceFactory.build({ beginning: '2020-01-01' });
      const service2 = ServiceFactory.build({ beginning: '2020-02-01' });

      it('returns -1', () => expect(ServicesComparer.compare(service1, service2)).toEqual(-1));
    });

    describe('if first service begins later than second service', () => {
      const service1 = ServiceFactory.build({ beginning: '2020-02-01' });
      const service2 = ServiceFactory.build({ beginning: '2020-01-01' });

      it('returns 1', () => expect(ServicesComparer.compare(service1, service2)).toEqual(1));
    });

    describe('if first service and second service begin at the same time', () => {
      const beginning = { beginning: '2020-01-01' };

      describe('if civil servant of first service is alphabetically lower ranked than second civil service', () => {
        const service1 = ServiceFactory.build({ ...beginning, civilServant: { fullName: 'Anna Gut' } });
        const service2 = ServiceFactory.build({ ...beginning, civilServant: { fullName: 'Joseph Gut' } });

        it('returns -1', () => expect(ServicesComparer.compare(service1, service2)).toEqual(-1));
      });

      describe('if civil servant of first service is alphabetically higher ranked than second civil service', () => {
        const service1 = ServiceFactory.build({ ...beginning, civilServant: { fullName: 'Zeran Gut' } });
        const service2 = ServiceFactory.build({ ...beginning, civilServant: { fullName: 'Joseph Gut' } });

        it('returns 1', () => expect(ServicesComparer.compare(service1, service2)).toEqual(1));
      });

      describe('when string compare is not available', () => {
        const { localeCompare } = String.prototype;

        beforeEach(() => delete String.prototype.localeCompare);
        afterEach(() => {
          // eslint-disable-next-line no-extend-native
          String.prototype.localeCompare = localeCompare;
        });

        const service1 = ServiceFactory.build({ ...beginning, civilServant: { fullName: 'Zeran Gut' } });
        const service2 = ServiceFactory.build({ ...beginning, civilServant: { fullName: 'Joseph Gut' } });

        it('returns -1', () => expect(ServicesComparer.compare(service1, service2)).toEqual(0));
      });
    });
  });
});
