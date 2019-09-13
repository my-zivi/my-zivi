import { IconLookup, library } from '@fortawesome/fontawesome-svg-core';
import { faCheckSquare } from '@fortawesome/free-regular-svg-icons/faCheckSquare';
import { faClock } from '@fortawesome/free-regular-svg-icons/faClock';
import { faHourglass } from '@fortawesome/free-regular-svg-icons/faHourglass';
import { faPlusSquare } from '@fortawesome/free-regular-svg-icons/faPlusSquare';
import { faSave } from '@fortawesome/free-regular-svg-icons/faSave';
import { faSquare } from '@fortawesome/free-regular-svg-icons/faSquare';
import { faTrashAlt } from '@fortawesome/free-regular-svg-icons/faTrashAlt';
import { faUser } from '@fortawesome/free-regular-svg-icons/faUser';
import { faAngleDoubleLeft } from '@fortawesome/free-solid-svg-icons/faAngleDoubleLeft';
import { faAngleDoubleRight } from '@fortawesome/free-solid-svg-icons/faAngleDoubleRight';
import { faArrowCircleLeft } from '@fortawesome/free-solid-svg-icons/faArrowCircleLeft';
import { faCheck } from '@fortawesome/free-solid-svg-icons/faCheck';
import { faDownload } from '@fortawesome/free-solid-svg-icons/faDownload';
import { faEdit } from '@fortawesome/free-solid-svg-icons/faEdit';
import { faEnvelope } from '@fortawesome/free-solid-svg-icons/faEnvelope';
import { faExclamation } from '@fortawesome/free-solid-svg-icons/faExclamation';
import { faPrint } from '@fortawesome/free-solid-svg-icons/faPrint';
import { faSpinner } from '@fortawesome/free-solid-svg-icons/faSpinner';
import { faSync } from '@fortawesome/free-solid-svg-icons/faSync';

export const Icons = () => {
  library.add(
    faCheck,
    faExclamation,
    faSquare,
    faSync,
    faEdit,
    faCheckSquare,
    faPrint,
    faDownload,
    faUser,
    faPlusSquare,
    faAngleDoubleRight,
    faAngleDoubleLeft,
    faTrashAlt,
    faSpinner,
    faArrowCircleLeft,
    faClock,
    faHourglass,
    faSave,
    faEnvelope,
  );
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

const DownloadIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'download',
};

const ArrowLeftIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'arrow-circle-left',
};

const SyncSolidIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'sync',
};

const EditSolidIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'edit',
};

const CheckSquareRegularIcon: IconLookup = {
  prefix: 'far',
  iconName: 'check-square',
};

const CheckRegularIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'check',
};

const DoubleAngleRightIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'angle-double-right',
};

const DoubleAngleLeftIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'angle-double-left',
};

const UserIcon: IconLookup = {
  prefix: 'far',
  iconName: 'user',
};

const PrintSolidIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'print',
};

const PlusSquareRegularIcon: IconLookup = {
  prefix: 'far',
  iconName: 'plus-square',
};

const TrashAltRegularIcon: IconLookup = {
  prefix: 'far',
  iconName: 'trash-alt',
};

const SpinnerSolidIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'spinner',
};

const ClockRegularIcon: IconLookup = {
  prefix: 'far',
  iconName: 'clock',
};

const HourGlassRegularIcon: IconLookup = {
  prefix: 'far',
  iconName: 'hourglass',
};

const SaveRegularIcon: IconLookup = {
  prefix: 'far',
  iconName: 'save',
};

const MailSolidIcon: IconLookup = {
  prefix: 'fas',
  iconName: 'envelope',
};

export {
  CheckSolidIcon,
  ExclamationSolidIcon,
  SquareRegularIcon,
  SyncSolidIcon,
  EditSolidIcon,
  CheckSquareRegularIcon,
  PrintSolidIcon,
  PlusSquareRegularIcon,
  TrashAltRegularIcon,
  SpinnerSolidIcon,
  UserIcon,
  DoubleAngleRightIcon,
  DoubleAngleLeftIcon,
  CheckRegularIcon,
  ClockRegularIcon,
  HourGlassRegularIcon,
  SaveRegularIcon,
  MailSolidIcon,
  DownloadIcon,
  ArrowLeftIcon,
};
