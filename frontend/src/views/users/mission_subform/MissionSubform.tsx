import Button from 'reactstrap/lib/Button';
import { MainStore } from '../../../stores/mainStore';
import { MissionStore } from '../../../stores/missionStore';
import * as React from 'react';
import { Mission, User } from '../../../types';
import { inject } from 'mobx-react';
import { SpecificationStore } from 'src/stores/specificationStore';
import injectSheet, { WithSheet } from 'react-jss';
import createStyles from 'src/utilities/createStyles';
import { MissionModal } from '../MissionModal';
import { missionSchema } from '../schemas';
import { UserStore } from 'src/stores/userStore';
import MissionOverviewTable from './MissionOverviewTable';

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
      marginTop: '-0.5rem',
    },
  });

@inject('mainStore', 'missionStore', 'specificationStore', 'userStore')
class MissionSubformInner extends React.Component<Props, MissionSubformState> {
  constructor(props: Props) {
    super(props);

    this.state = { mission_id: undefined, new_mission: false };
  }

  public render() {
    const { user, missionStore, mainStore, userStore, specificationStore, classes, theme } = this.props;

    return (
      <>
        <h3>Einsatzplanung</h3>
        <p>
          Um eine Einsatzplanung zu erfassen, klicke unten auf "Neue Einsatzplanung hinzufügen", wähle ein Pflichtenheft
          aus und trage
          Start- und Enddatum ein.
          <br/>
          Klicke nach dem Erstellen der Einsatzplanung auf "Drucken", um ein PDF zu generieren. Dieses kannst du dann an
          den Einsatzbetrieb
          schicken.
        </p>
        <p>
          <b>Beachte:</b> Zivi-Einsätze im Naturschutz müssen an einem Montag beginnen und an einem Freitag enden,
          ausser es handelt sich um
          deinen letzten Zivi Einsatz und du leistest nur noch die verbleibenden Resttage.
        </p>
        {user && (
          <div>
            <MissionOverviewTable
              mainStore={mainStore}
              missionStore={missionStore}
              userStore={userStore}
              specificationStore={specificationStore}
              user={user}
              classes={classes}
              missionModalIsOpen={!!this.state.mission_id}
              theme={theme}
              onModalClose={() => this.setState({ mission_id: undefined })}
              onModalOpen={(mission: Mission) => this.setState({ mission_id: mission.id })} />

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
          </div>
        )}
        {!user && <div>Loading...</div>}
      </>
    );
  }
}

export const MissionSubform = injectSheet(styles)(MissionSubformInner);
