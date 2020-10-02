import Factory, { Overrides } from 'js/tests/factories/Factory';
import { range } from 'lodash';

export default {
  buildList<T>(factory: Factory<T>, times: number, overrides?: Overrides<T>): T[] {
    return range(times).map(_i => factory.build(overrides));
  },
};
