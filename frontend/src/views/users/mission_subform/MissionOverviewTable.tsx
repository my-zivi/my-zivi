import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import moment from 'moment';
import * as React from 'react';
import { WithSheet } from 'react-jss';
import { UncontrolledTooltip } from 'reactstrap';
import Button from 'reactstrap/lib/Button';
import { DeleteButton } from '../../../form/DeleteButton';
import { OverviewTable } from '../../../layout/OverviewTable';
import { MainStore } from '../../../stores/mainStore';
import { MissionStore } from '../../../stores/missionStore';
import { SpecificationStore } from '../../../stores/specificationStore';
import { UserStore } from '../../../stores/userStore';
import { Mission, Specification, User } from '../../../types';
import {
  CheckSquareRegularIcon,
  EditSolidIcon,
  MailSolidIcon,
  PlusSquareRegularIcon,
  PrintSolidIcon,
  SquareRegularIcon,
  TrashAltRegularIcon,
} from '../../../utilities/Icon';
import { MissionModal } from '../MissionModal';
import { missionSchema } from '../schemas';
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

async function onMissionDeleteConfirm(mission: Mission, missionStore: MissionStore, userStore: UserStore) {
  console.dir(mission); // tslint:disable-line
  (window as any).mission = mission;
  await missionStore.delete(mission.id!);
  await userStore.fetchOne(mission.user_id);
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
              <DeleteButton onConfirm={() => onMissionDeleteConfirm(mission, missionStore!, userStore!)}>
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
