import React, { Component } from 'react';
import _ from 'lodash';
import { api } from '../../../utils/api';
import DatePicker from '../../tags/InputFields/DatePicker';
import { MissionTable } from './missions';
import moment from 'moment-timezone';
import { ReportSheets } from './report_sheets';
import Toast from '../../../utils/toast';

export default class Commitment extends Component {
  // COMPONENT-RELATED STUFF
  constructor(props) {
    super(props);

    this.state = {
      missions: [{ id: 'new' }],
      reportSheets: [],
      specifications: [],
    };

    this.addReportSheet = this.addReportSheet.bind(this);
    this.calculateMissionDays = this.calculateMissionDays.bind(this);
    // react fires an event for each keydown, means if you wanna do a 180 days mission, it will fire 3 calls to the api
    // with debounce, it waits 500 milliseconds after you finished typing and will send the event
    this.calculateMissionEndDate = _.debounce(this.calculateMissionEndDate.bind(this), 500);
    this.deleteMission = this.deleteMission.bind(this);
    this.handleMissionChange = this.handleMissionChange.bind(this);
    this.saveMission = this.saveMission.bind(this);
    this.setReceivedDraft = this.setReceivedDraft.bind(this);
  }

  componentDidMount() {
    this.props.onLoading('missions', true);
    this.props.onLoading('specifications', true);
    this.props.onLoading('reportSheets', true);
    this.getMissions();
    this.getReportSheets();
    this.getSpecifications();
  }

  // API GETTER METHODS
  getMissions() {
    const { userIdParam } = this.props;
    const route = userIdParam ? `user/${userIdParam}/missions` : 'user/missions';

    api()
      .get(route)
      .then(response => {
        this.setState({
          missions: response.data.concat([{ id: 'new' }]),
        });

        this.props.onLoading('missions', false);
      })
      .catch(error => {
        this.props.onError(error);
      });
  }

  getReportSheets() {
    const { userIdParam } = this.props;
    const apiRoute = userIdParam ? userIdParam : 'me';

    api()
      .get('reportsheet/user/' + apiRoute)
      .then(response => {
        this.setState({
          reportSheets: response.data,
        });
        this.props.onLoading('reportSheets', false);
      })
      .catch(error => {
        this.props.onError(error);
      });
  }

  getSpecifications() {
    api()
      .get('specification/me')
      .then(response => {
        this.setState({
          specifications: response.data,
        });
        this.props.onLoading('specifications', false);
      })
      .catch(error => {
        this.props.onError(error);
      });
  }

  // CHANGE HANDLERS
  // report sheets does not need a change handler
  changeMissionResult(mission_id, key, value) {
    const { missions } = this.state;

    const missionToUpdate = missions.findIndex(obj => obj.id === mission_id);
    const updatedMission = { ...missions[missionToUpdate], [key]: value };

    this.setState({
      missions: [...missions.slice(0, missionToUpdate), updatedMission, ...missions.slice(missionToUpdate + 1)],
    });
  }

  handleMissionChange(e, mission_id) {
    if (e.target.type === 'checkbox') {
      this.changeMissionResult(mission_id, e.target.name, e.target.checked ? 1 : 0);
    } else if (e.target.hasAttribute('data-datepicker')) {
      this.changeMissionResult(mission_id, e.target.name, DatePicker.dateFormat_CH2EN(e.target.value));
    } else {
      this.changeMissionResult(mission_id, e.target.name, e.target.value);
    }
  }

  // SUBMIT STUFF
  saveMission(mission_id) {
    // API will stripe out things like created_at or updated_at, so no need to modify the object from the state
    const { missions } = this.state;
    const { userIdParam } = this.props;
    let mission = missions.find(el => el.id === mission_id);

    if (moment(mission.start).isoWeekday() !== 1 && !mission.probation_period) {
      Toast.showError('Falscher Einsatzbeginn', 'Erster Einsatztag muss zwingend ein Montag sein!', null, null);
      return;
    }

    if (moment(mission.end).isoWeekday() !== 5 && +mission.mission_type !== 2 && !mission.probation_period) {
      Toast.showError(
        'Falsches Einsatzende',
        'Letzter Einsatztag muss zwingend ein Freitag sein! (Ausnahme: letzter Einsatz oder Probeeinsatz)',
        null,
        null
      );
      return;
    }

    if (!moment(mission.start).isSameOrBefore(moment(mission.end))) {
      Toast.showError('Falsches Einsatzdauer', 'Erster Einsatztag nach dem letzten Einsatztag', null, null);
      return;
    }

    this.props.onLoading('missions', true);

    if (mission_id === 'new') {
      mission.user = userIdParam ? userIdParam : 'me';
      api()
        .post('mission', mission)
        .then(() => {
          Toast.showSuccess('Speichern erfolgreich', 'Neuer Einsatz wurde erfolgreich gespeichert.');
          window.$('[data-dismiss=modal]').trigger({ type: 'click' });
          this.props.onLoading('reportSheets', true);
          this.getMissions();
          this.getReportSheets();
        })
        .catch(error => {
          this.props.onLoading('missions', false);
          Toast.showError('Speichern fehlgeschlagen', 'Neuer Einsatz konnte nicht gespeichert werden', error, path =>
            this.props.history.push(path)
          );
        });
    } else {
      api()
        .put('mission/' + mission.id, mission)
        .then(() => {
          Toast.showSuccess('Speichern erfolgreich', 'Einsatz wurde erfolgreich aktualisiert.');
          window.$('[data-dismiss=modal]').trigger({ type: 'click' });
          this.props.onLoading('reportSheets', true);
          this.getMissions();
          this.getReportSheets();
        })
        .catch(error => {
          this.props.onLoading('missions', false);
          Toast.showError('Speichern fehlgeschlagen', 'Einsatz konnte nicht gespeichert werden', error, path =>
            this.props.history.push(path)
          );
        });
    }
  }

  // ADDITIONAL FUNCTIONS
  addReportSheet(mission_id) {
    const { userIdParam } = this.props;
    this.props.onLoading('reportSheets', true);

    api()
      .put('reportsheet', {
        user: userIdParam ? userIdParam : null,
        mission: mission_id,
      })
      .then(response => {
        this.getReportSheets();
        Toast.showSuccess('Hinzufügen erfolgreich', 'Spesenblatt hinzugefügt');
      })
      .catch(error => {
        this.props.onLoading('reportSheets', false);
        Toast.showError('Hinzugefügen fehlgeschlagen', 'Spesenblatt konnte nicht hinzugefügt werden', error, path =>
          this.props.history.push(path)
        );
      });
  }

  calculateMissionDays(mission_id) {
    const { missions } = this.state;
    const mission = missions.find(el => el.id === mission_id);

    if (mission.start && mission.start < mission.end) {
      api()
        .get('diensttage', {
          params: {
            start: mission.start,
            end: mission.end,
            long_mission: mission.long_mission,
          },
        })
        .then(response => {
          this.changeMissionResult(mission_id, 'calculated_mission_days', response.data);
        })
        .catch(error => {
          Toast.showError('Berechnung der Diensttage fehlgeschlagen', 'Serverfehler', error);
        });
    }
  }

  calculateMissionEndDate(mission_id) {
    const { missions } = this.state;
    const mission = missions.find(el => el.id === mission_id);

    if (mission.start && mission.calculated_mission_days > 0) {
      api()
        .get('diensttageEndDate', {
          params: {
            start: mission.start,
            days: mission.calculated_mission_days,
            long_mission: mission.long_mission,
          },
        })
        .then(response => {
          this.changeMissionResult(mission_id, 'end', response.data);
        })
        .catch(error => {
          Toast.showError('Berechnung der Diensttage fehlgeschlagen', 'Serverfehler', error);
        });
    }
  }

  deleteMission(id) {
    this.props.onLoading('missions', true);

    api()
      .delete('mission/' + id)
      .then(() => {
        this.getMissions();
        Toast.showSuccess('Löschen erfolgreich', 'Einsatz konnte gelöscht werden');
      })
      .catch(error => {
        this.props.onLoading('missions', false);
        Toast.showError('Speichern fehlgeschlagen', 'Einsatz konnte nicht gelöscht werden', error);
      });
  }

  setReceivedDraft(mission_id) {
    this.props.onLoading('missions', true);
    this.props.onLoading('reportSheets', true);

    api()
      .post(`mission/${mission_id}/receivedDraft`)
      .then(() => {
        this.getMissions();
        this.getReportSheets();
      })
      .error(error => {
        this.props.onError(error);
      });
  }

  render() {
    const { missions, reportSheets, specifications } = this.state;
    const { userIdParam } = this.props;

    return (
      <div>
        <MissionTable
          addReportSheet={this.addReportSheet}
          calculateMissionDays={this.calculateMissionDays}
          calculateMissionEndDate={this.calculateMissionEndDate}
          deleteMission={this.deleteMission}
          missions={missions}
          onChange={this.handleMissionChange}
          saveMission={this.saveMission}
          specifications={specifications}
          setReceivedDraft={this.setReceivedDraft}
          userIdParam={userIdParam}
        />
        <ReportSheets reportSheets={reportSheets} />
      </div>
    );
  }
}
