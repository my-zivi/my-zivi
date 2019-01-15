import { library, IconLookup } from '@fortawesome/fontawesome-svg-core';
import { faSync } from '@fortawesome/free-solid-svg-icons/faSync';
import { faCheck } from '@fortawesome/free-solid-svg-icons/faCheck';
import { faSquare } from '@fortawesome/free-regular-svg-icons/faSquare';
import { faExclamation } from '@fortawesome/free-solid-svg-icons/faExclamation';

export const Icons = () => {
  library.add(faCheck, faExclamation, faSquare, faSync);
};

const CheckSolidIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'check',
};

const ExclamationSolidIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'exclamation',
};

const SquareRegularIcon: IconLookup = {
  prefix: 'far',
  iconName: 'square',
};

const SyncSolidIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'sync',
};

export { CheckSolidIcon, ExclamationSolidIcon, SquareRegularIcon, SyncSolidIcon };
