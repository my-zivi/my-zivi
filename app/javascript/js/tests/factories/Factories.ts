import { range } from 'lodash';
import Factory, { Overrides } from '~/js/tests/factories/Factory';

export default {
  buildList<T>(factory: Factory<T>, times: number, overrides?: Overrides<T>): T[] {
    return range(times).map(() => factory.build(overrides));
  },
};
