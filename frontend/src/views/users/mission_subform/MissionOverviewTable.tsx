import { OverviewTable } from '../../../layout/OverviewTable';
import Button from 'reactstrap/lib/Button';
import { Mission, Specification, User } from '../../../types';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  CheckSquareRegularIcon,
  EditSolidIcon,
  MailSolidIcon,
  PlusSquareRegularIcon,
  PrintSolidIcon,
  SquareRegularIcon,
  TrashAltRegularIcon,
} from '../../../utilities/Icon';
import { DeleteButton } from '../../../form/DeleteButton';
import { MissionModal } from '../MissionModal';
import { missionSchema } from '../schemas';
import * as React from 'react';
import { WithSheet } from 'react-jss';
import { MainStore } from '../../../stores/mainStore';
import { MissionStore } from '../../../stores/missionStore';
import { UserStore } from '../../../stores/userStore';
import { SpecificationStore } from '../../../stores/specificationStore';
import { UncontrolledTooltip } from 'reactstrap';
import moment from 'moment';
import { Link } from 'react-router-dom';

interface OverviewTableParams extends WithSheet<string, {}> {
  mainStore?: MainStore;
  missionStore?: MissionStore;
  userStore?: UserStore;
  specificationStore?: SpecificationStore;
  user: User;
  onModalOpen: (mission: Mission) => void;
  onModalClose: (_?: React.MouseEvent<HTMLButtonElement>) => void;
  missionModalIsOpen: boolean;
}

function onMissionTableSubmit(missionStore?: MissionStore, userStore?: UserStore) {
  return (mission: Mission) => {
    return missionStore!.put(missionSchema.cast(mission)).then(() => {
      void userStore!.fetchOne(mission.user_id);
    }) as Promise<void>;
  };
}

function renderFeedbackButton(mission: Mission) {
  console.log(mission.user);
  if (mission.feedback_done || moment().isBefore(moment(mission.end!))) {
    return;
  }

  return (
    <Link to={`/mission/${mission.id}/feedback`}>
      <Button color={'info'} type={'button'} className="mr-1">
        <FontAwesomeIcon icon={MailSolidIcon} /> <span>Feedback senden</span>
      </Button>
    </Link>
  );
}

export default (params: OverviewTableParams) => {
  const { user, mainStore, missionStore, classes, userStore, specificationStore, onModalOpen, onModalClose, missionModalIsOpen } = params;

  return (
    <OverviewTable
      data={user.missions}
      columns={[
        {
          id: 'specification',
          label: 'Pflichtenheft',
          format: (m: Mission) => {
            const spec = specificationStore!.entities.find((sp: Specification) => sp.id === m.specification_id);
            return `${spec ? spec.name : ''} (${m.specification_id})`;
          },
        },
        {
          id: 'start',
          label: 'Start',
          format: (mission: Mission) => (mission.start ? mainStore!.formatDate(mission.start) : ''),
        },
        {
          id: 'end',
          label: 'Ende',
          format: (mission: Mission) => (mission.end ? mainStore!.formatDate(mission.end) : ''),
        },
        {
          id: 'draft_date',
          label: '',
          format: (m: Mission) => (
            <>
              <span id={`reportSheetState-${m.id}`}>
                <FontAwesomeIcon icon={m.draft ? CheckSquareRegularIcon : SquareRegularIcon} color={m.draft ? 'green' : 'black'} />
              </span>
              <UncontrolledTooltip target={`reportSheetState-${m.id}`}>Aufgebot erhalten</UncontrolledTooltip>
            </>
          ),
        },
      ]}
      renderActions={(mission: Mission) => (
        <div className={classes.hideButtonText}>
          <a className={'btn btn-link'} href={mainStore!.apiURL('missions/' + mission.id + '/draft', {}, true)} target={'_blank'}>
            <FontAwesomeIcon icon={PrintSolidIcon} /> <span>Drucken</span>
          </a>
          <Button color={'warning'} type={'button'} className="mr-1" onClick={() => onModalOpen(mission)}>
            <FontAwesomeIcon icon={EditSolidIcon} /> <span>Bearbeiten</span>
          </Button>
          {renderFeedbackButton(mission)}
          {mainStore!.isAdmin() && (
            <>
              <DeleteButton onConfirm={() => missionStore!.delete(mission.id!)}>
                <FontAwesomeIcon icon={TrashAltRegularIcon} /> <span>Löschen</span>
              </DeleteButton>{' '}
              <Button color={'success'} type={'button'}>
                <FontAwesomeIcon icon={PlusSquareRegularIcon} /> <span>Spesenblatt</span>
              </Button>
            </>
          )}
          <MissionModal
            onSubmit={onMissionTableSubmit(missionStore, userStore)}
            user={user}
            values={mission}
            onClose={onModalClose}
            isOpen={missionModalIsOpen}
          />
        </div>
      )}
    />
  );
};
