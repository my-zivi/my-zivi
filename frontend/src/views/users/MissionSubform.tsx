import Button from 'reactstrap/lib/Button';
import { MainStore } from '../../stores/mainStore';
import { MissionStore } from '../../stores/missionStore';
import * as React from 'react';
import { Mission, User, Specification } from '../../types';
import { OverviewTable } from 'src/layout/OverviewTable';
import {
  SquareRegularIcon,
  CheckSquareRegularIcon,
  PrintSolidIcon,
  EditSolidIcon,
  TrashAltRegularIcon,
  PlusSquareRegularIcon,
} from 'src/utilities/Icon';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { inject } from 'mobx-react';
import { SpecificationStore } from 'src/stores/specificationStore';
import injectSheet, { WithSheet } from 'react-jss';
import createStyles from 'src/utilities/createStyles';
import { MissionModal } from './MissionModal';
import { missionSchema } from './schemas';
import { UserStore } from 'src/stores/userStore';
import { DeleteButton } from '../../form/DeleteButton';

interface Props extends WithSheet<typeof styles> {
  mainStore?: MainStore;
  missionStore?: MissionStore;
  specificationStore?: SpecificationStore;
  userStore?: UserStore;
  user: User;
}

interface MissionSubformState {
  mission_id?: number;
  new_mission: boolean;
}

const styles = () =>
  createStyles({
    hideButtonText: {
      '@media (max-width: 1024px)': {
        '& button': {
          width: '40px',
        },
        '& span': {
          display: 'none',
        },
      },
    },
  });

@inject('mainStore', 'missionStore', 'specificationStore', 'userStore')
class MissionSubformInner extends React.Component<Props, MissionSubformState> {
  constructor(props: Props) {
    super(props);

    this.state = { mission_id: undefined, new_mission: false };
  }

  public render() {
    const { user, mainStore, missionStore, classes, userStore } = this.props;

    return (
      <>
        <h3>Einsatzplanung</h3>
        <p>
          Um eine Einsatzplanung zu erfassen, klicke unten auf "Neue Einsatzplanung hinzufügen", wähle ein Pflichtenheft aus und trage
          Start- und Enddatum ein.
          <br />
          Klicke nach dem Erstellen der Einsatzplanung auf "Drucken", um ein PDF zu generieren. Dieses kannst du dann an den Einsatzbetrieb
          schicken.
        </p>
        <p>
          <b>Beachte:</b> Zivi-Einsätze im Naturschutz müssen an einem Montag beginnen und an einem Freitag enden, ausser es handelt sich um
          deinen letzten Zivi Einsatz und du leistest nur noch die verbleibenden Resttage.
        </p>
        {user && (
          <>
            <OverviewTable
              data={user.missions}
              columns={[
                {
                  id: 'specification',
                  label: 'Pflichtenheft',
                  format: (m: Mission) => {
                    const spec = this.props.specificationStore!.entities.find((sp: Specification) => sp.id === m.specification_id);
                    return `${spec ? spec.name : ''} (${m.specification_id})`;
                  },
                },
                {
                  id: 'start',
                  label: 'Start',
                  format: (m: Mission) => (m.start ? mainStore!.formatDate(m.start) : ''),
                },
                {
                  id: 'end',
                  label: 'Ende',
                  format: (m: Mission) => (m.end ? mainStore!.formatDate(m.end) : ''),
                },
                {
                  id: 'draft_date',
                  label: '',
                  format: (m: Mission) => <FontAwesomeIcon icon={m.draft ? CheckSquareRegularIcon : SquareRegularIcon} />,
                },
              ]}
              renderActions={(m: Mission) => (
                <div className={classes.hideButtonText}>
                  <a className={'btn btn-link'} href={mainStore!.apiURL('missions/' + m.id + '/draft', {}, true)} target={'_blank'}>
                    <FontAwesomeIcon icon={PrintSolidIcon} /> <span>Drucken</span>
                  </a>
                  <Button color={'warning'} type={'button'} onClick={() => this.handleOpen(m.id)}>
                    <FontAwesomeIcon icon={EditSolidIcon} /> <span>Bearbeiten</span>
                  </Button>{' '}
                  <DeleteButton
                    onConfirm={() => {
                      missionStore!.delete(m.id!);
                    }}
                  >
                    <FontAwesomeIcon icon={TrashAltRegularIcon} /> <span>Löschen</span>
                  </DeleteButton>{' '}
                  <Button color={'success'} type={'button'}>
                    <FontAwesomeIcon icon={PlusSquareRegularIcon} /> <span>Spesenblatt</span>
                  </Button>
                  <MissionModal
                    onSubmit={(mission: Mission) =>
                      missionStore!.put(missionSchema.cast(mission)).then(() => {
                        userStore!.fetchOne(m.user_id);
                      })
                    }
                    user={user}
                    values={m}
                    onClose={this.handleClose}
                    isOpen={this.state.mission_id ? true : false}
                  />
                </div>
              )}
            />
            <Button
              color={'success'}
              type={'button'}
              onClick={() => {
                this.setState({ new_mission: true });
              }}
            >
              Neue Einsatzplanung hinzufügen
            </Button>
            <MissionModal
              onSubmit={(mission: Mission) => missionStore!.post(missionSchema.cast(mission))}
              user={user}
              onClose={() => {
                this.setState({ new_mission: false });
              }}
              isOpen={this.state.new_mission}
            />
          </>
        )}
        {!user && <div>Loading...</div>}
      </>
    );
  }

  handleOpen = (id?: number): void => {
    this.setState({ mission_id: id });
  };

  handleClose = (_?: React.MouseEvent<HTMLButtonElement>) => {
    this.setState({ mission_id: undefined });
  };
}

export const MissionSubform = injectSheet(styles)(MissionSubformInner);
