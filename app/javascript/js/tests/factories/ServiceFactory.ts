import { Service } from 'js/organizations/services/embedded_app/types';

import * as _ from 'lodash';
import Factory from 'js/tests/factories/Factory';
import { name } from 'faker';

const ServiceFactory: Factory<Service> = {
  build(overrides?: Record<string, unknown> | Service): Service {
    const defaultService: Service = {
      beginning: '2020-01-06',
      ending: '2020-02-07',
      definitive: true,
      civilServant: {
        fullName: name.findName(),
      },
    };

    return _.merge(defaultService, overrides);
  },
};

export default ServiceFactory;
