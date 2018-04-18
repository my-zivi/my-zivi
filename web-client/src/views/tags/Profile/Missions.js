import Inferno from 'inferno';
import VNodeFlags from 'inferno-vnode-flags';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import axios from 'axios';
import ApiService from '../../../utils/api';
import InputField from '../InputFields/InputField';
import InputFieldWithHelpText from '../InputFields/InputFieldWithHelpText';
import InputCheckbox from '../InputFields/InputCheckbox';
import DatePicker from '../InputFields/DatePicker';
import Toast from '../../../utils/toast';
import moment from 'moment-timezone';

export default class Missions extends Component {
  renderMissions = (self, mission, isAdmin) => {
    let missionKey = mission != null ? mission.id : 'newmission';

    let howerText_Tage =
      'Zeigt dir die Anzahl Tage an welche für den Einsatz voraussichtlich angerechnet werden. Falls während dem Einsatz Betriebsferien liegen werden die entsprechenden Tage abgezogen falls die Dauer zu kurz ist um diese mit Ferientagen kompensieren zu können. Feiertage innerhalb von Betriebsferien gelten auf alle Fälle als Dienstage.';

    var specification_options = [];
    specification_options.push(<option value="" />);
    for (var i = 0; i < self.state.specifications.length; i++) {
      if (self.state.specifications[i].active) {
        specification_options.push(<option value={'' + self.state.specifications[i].fullId}>{self.state.specifications[i].name}</option>);
      }
    }

    var aufgebotErhaltenButton = [];
    if (mission != null && mission.draft == null && isAdmin) {
      aufgebotErhaltenButton.push(
        <button
          class="btn btn-primary"
          type="button"
          onClick={() => {
            this.setReceivedDraft(self, missionKey);
          }}
        >
          Aufgebot erhalten
        </button>
      );
    }

    return (
      <div id={'einsatzModal' + (mission != null ? mission.id : '')} class="modal fade" role="dialog">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button id="einsatzModalClose" type="button" class="close" data-dismiss="modal">
                &times;
              </button>
              <h4 class="modal-title">Zivildiensteinsatz</h4>
            </div>
            <div class="modal-body">
              <form
                class="form-horizontal"
                action="javascript:;"
                onsubmit={() => {
                  this.saveMission(self, missionKey);
                }}
              >
                <div class="form-group">
                  <label class="control-label col-sm-3" for={missionKey + '_specification'}>
                    Pflichtenheft
                  </label>
                  <div class="col-sm-9">
                    <select
                      value={'' + self.state['result'][missionKey + '_specification']}
                      id={missionKey + '_specification'}
                      name={missionKey + '_specification'}
                      class="form-control"
                      onChange={e => self.handleSelectChange(e)}
                      required
                    >
                      {specification_options}
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <label class="control-label col-sm-3" for="newmission_mission_type">
                    Einsatzart
                  </label>
                  <div class="col-sm-9">
                    <select
                      value={'' + self.state['result'][missionKey + '_mission_type']}
                      id={missionKey + '_mission_type'}
                      name={missionKey + '_mission_type'}
                      class="form-control"
                      onChange={e => self.handleSelectChange(e)}
                    >
                      <option value="0" />
                      <option value="1">Erster Einsatz</option>
                      <option value="2">Letzter Einsatz</option>
                    </select>
                  </div>
                </div>
                <DatePicker
                  value={self.state['result'][missionKey + '_start']}
                  id={missionKey + '_start'}
                  label="Einsatzbeginn"
                  callback={e => {
                    self.handleDateChange(e, self);
                    this.getMissionDays(self, missionKey);
                  }}
                  callbackOrigin={self}
                />
                <DatePicker
                  value={self.state['result'][missionKey + '_end']}
                  id={missionKey + '_end'}
                  label="Einsatzende"
                  callback={e => {
                    self.handleDateChange(e, self);
                    this.getMissionDays(self, missionKey);
                  }}
                  callbackOrigin={self}
                />
                <InputFieldWithHelpText
                  value={self.state['result'][missionKey + '_days']}
                  id={missionKey + '_days'}
                  label="Tage"
                  popoverText={howerText_Tage}
                  callback={e => {
                    self.handleChange(e, self);
                    this.calculateMissionEndDate(e, self, missionKey);
                  }}
                  self={self}
                />
                <InputCheckbox
                  value={self.state['result'][missionKey + '_first_time']}
                  id={missionKey + '_first_time'}
                  label="Erster SWO Einsatz"
                  self={self}
                />
                <InputCheckbox
                  value={self.state['result'][missionKey + '_long_mission']}
                  id={missionKey + '_long_mission'}
                  label="Langer Einsatz oder Teil davon"
                  callback={e => {
                    self.handleChange(e);
                    this.getMissionDays(self, missionKey);
                  }}
                  self={self}
                />
                <InputCheckbox
                  value={self.state['result'][missionKey + '_probation_period']}
                  id={missionKey + '_probation_period'}
                  label="Probeeinsatz"
                  self={self}
                />
                <hr />
                <h4>Status</h4>
                {mission == null || mission.draft == null ? 'Provisorisch' : 'Aufgeboten, Aufgebot erhalten am ' + mission.draft}
                <hr />
                {mission == null || mission.draft == null || ApiService.isAdmin() ? (
                  <button class="btn btn-primary" type="submit">
                    Daten speichern
                  </button>
                ) : null}
                &nbsp;
                {aufgebotErhaltenButton}
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  };

  setReceivedDraft(self, missionKey) {
    self.setState({ loading: true, error: null });
    axios
      .post(ApiService.BASE_URL + 'mission/' + missionKey + '/receivedDraft', null, {
        headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
      })
      .then(response => {
        self.getUser();
        self.getReportSheets();
      })
      .catch(error => {
        self.setState({ error: error });
      });
  }

  getMissions(self) {
    let confirmedIcon = (
      <a data-toggle="popover" title="" data-content="Aufgebot erhalten">
        <span class="glyphicon glyphicon-check" style="color:green" />
      </a>
    );

    let draftOpenIcon = (
      <a data-toggle="popover" title="" data-content="Provisorisch">
        <span class="glyphicon glyphicon-unchecked" style="color:grey" />
      </a>
    );

    var missions = [];
    if (self.state.result.missions != null) {
      var m = self.state.result.missions;
      for (var i = 0; i < m.length; i++) {
        var name = m[i].specification;

        for (var s = 0; s < self.state.specifications.length; s++) {
          if (m[i].specification == self.state.specifications[s].id) {
            name = name + ' ' + self.state.specifications[s].name;
            break;
          }
        }

        let curMission = m[i];
        var deleteButton = [];
        var addButton = [];

        if (ApiService.isAdmin()) {
          deleteButton.push(
            <button
              class="btn btn-xs btn-danger"
              onClick={() => {
                if (confirm('Möchten Sie diesen Einsatz wirklich löschen?')) {
                  self.missionTag.deleteMission(self, curMission);
                }
              }}
            >
              <span class="glyphicon glyphicon-trash" aria-hidden="true" /> Löschen
            </button>
          );
          addButton.push(
            <button
              data-toggle="popover"
              data-content="Neues Meldeblatt hinzufügen"
              class="btn btn-xs btn-success"
              onClick={() => {
                self.addReportSheet(curMission.id);
              }}
              title=""
            >
              <span class="glyphicon glyphicon-plus" aria-hidden="true" /> Meldeblatt
            </button>
          );
        }

        var feedbackButton = [];

        if (
          moment().isSameOrAfter(moment(m[i].end)) &&
          m[i].feedback_done != 1 &&
          self.props.params.userid === undefined && // Only allow feedbacks for own user
          curMission.draft != null // Only allow feedbacks for confirmed missions
        ) {
          feedbackButton.push(
            <a href={'/user_feedback/' + m[i].id} class="btn btn-xs btn-info">
              <span class="glyphicon glyphicon-list" aria-hidden="true" /> Feedback
            </a>
          );
        }

        missions.push(
          <tr>
            <td>{name}</td>
            <td>{moment(m[i].start, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
            <td>{moment(m[i].end, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
            <td>{curMission == null || curMission.draft == null ? draftOpenIcon : confirmedIcon}</td>
            <td>
              <a
                class="btn btn-xs"
                href={ApiService.BASE_URL + 'mission/' + curMission.id + '/draft?jwttoken=' + encodeURI(localStorage.getItem('jwtToken'))}
                target="_blank"
              >
                <span class="glyphicon glyphicon-print" aria-hidden="true" /> Drucken
              </a>
            </td>
            <td>
              <div>
                <button class="btn btn-xs btn-warning" data-toggle="modal" data-target={'#einsatzModal' + m[i].id}>
                  <span class="glyphicon glyphicon-edit" aria-hidden="true" /> Bearbeiten
                </button>&nbsp;
                {deleteButton}&nbsp;
                {addButton}&nbsp;
                {feedbackButton}
              </div>
            </td>
          </tr>
        );
        missions.push(this.renderMissions(self, m[i], ApiService.isAdmin()));
      }
    }

    return missions;
  }

  saveMission(self, missionKey) {
    var newMission = {
      user: self.state.result.id,
      specification: self.state.result[missionKey + '_specification'],
      mission_type: self.state.result[missionKey + '_mission_type'],
      start: self.state.result[missionKey + '_start'],
      end: self.state.result[missionKey + '_end'],
      first_time: self.state.result[missionKey + '_first_time'],
      long_mission: self.state.result[missionKey + '_long_mission'],
      probation_period: self.state.result[missionKey + '_probation_period'],
    };

    if (moment(newMission['start']).isoWeekday() != 1 && newMission['probation_period'] != 1) {
      Toast.showError('Falscher Einsatzbeginn', 'Erster Einsatztag muss zwingend ein Montag sein!', null, self.context);
      return;
    }

    if (moment(newMission['end']).isoWeekday() != 5 && newMission['mission_type'] != 2 && newMission['probation_period'] != 1) {
      Toast.showError(
        'Falsches Einsatzende',
        'Letzter Einsatztag muss zwingend ein Freitag sein! (Ausnahme: letzter Einsatz)',
        null,
        self.context
      );
      return;
    }

    if (!moment(newMission['start']).isSameOrBefore(moment(newMission['end']))) {
      Toast.showError('Falsches Einsatzdauer', 'Erster Einsatztag nach dem letzten Einsatztag', null, self.context);
      return;
    }

    self.setState({ loading: true, error: null });
    if (missionKey == 'newmission') {
      axios
        .post(ApiService.BASE_URL + 'mission', newMission, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
        .then(response => {
          Toast.showSuccess('Speichern erfolgreich', 'Neuer Einsatz konnte gespeichert werden');
          $('[data-dismiss=modal]').trigger({ type: 'click' });
          self.getUser();
        })
        .catch(error => {
          self.setState({ loading: false, error: null });
          Toast.showError('Speichern fehlgeschlagen', 'Neuer Einsatz konnte nicht gespeichert werden', error, self.context);
        });
    } else {
      axios
        .put(ApiService.BASE_URL + 'mission/' + missionKey, newMission, {
          headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') },
        })
        .then(response => {
          Toast.showSuccess('Speichern erfolgreich', 'Einsatz konnte gespeichert werden');
          $('[data-dismiss=modal]').trigger({ type: 'click' });
          self.getUser();
          self.getReportSheets();
        })
        .catch(error => {
          self.setState({ loading: false, error: null });
          Toast.showError('Speichern fehlgeschlagen', 'Einsatz konnte nicht gespeichert werden', error, self.context);
        });
    }
  }

  deleteMission(self, mission) {
    self.setState({ loading: true, error: null });
    axios
      .delete(ApiService.BASE_URL + 'mission/' + mission.id, { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } })
      .then(response => {
        Toast.showSuccess('Löschen erfolgreich', 'Einsatz konnte gelöscht werden');
        self.getUser();
        self.getReportSheets();
      })
      .catch(error => {
        Toast.showError('Löschen fehlgeschlagen', 'Einsatz konnte nicht gelöscht werden', error, self.context);
        self.setState({ loading: false, error: null });
      });
  }

  calculateMissionEndDate(e, self, missionKey) {
    self.state['result'][e.target.name] = e.target.value; // update days
    self.setState(self.state);
    let startDate = self.state['result'][missionKey + '_start'];

    if (e.target.value && e.target.value > 0 && startDate) {
      let long_mission = self.state.result[missionKey + '_long_mission'];
      if (!long_mission) {
        long_mission = false;
      }

      axios
        .get(
          ApiService.BASE_URL +
            'diensttageEndDate?start=' +
            startDate +
            '&days=' +
            self.state.result[missionKey + '_days'] +
            '&long_mission=' +
            long_mission,
          { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } }
        )
        .then(response => {
          if (response && response.data) {
            self.state.result[missionKey + '_end'] = response.data;
            self.setState(self.state);
          }
        })
        .catch(error => {
          self.setState({ loading: false, error: null });
        });
    }
  }

  getMissionDays(self, missionKey) {
    self.state.result[missionKey + '_days'] = '';
    self.setState(self.state);

    let long_mission = self.state.result[missionKey + '_long_mission'];
    if (!long_mission) {
      long_mission = false;
    }

    if (self.state.result[missionKey + '_start'] && self.state.result[missionKey + '_end']) {
      axios
        .get(
          ApiService.BASE_URL +
            'diensttage?start=' +
            self.state.result[missionKey + '_start'] +
            '&end=' +
            self.state.result[missionKey + '_end'] +
            '&long_mission=' +
            long_mission,
          { headers: { Authorization: 'Bearer ' + localStorage.getItem('jwtToken') } }
        )
        .then(response => {
          if (response && response.data) {
            self.state.result[missionKey + '_days'] = response.data;
            self.setState(self.state);
          }
        })
        .catch(error => {
          self.setState({ loading: false, error: null });
        });
    }
  }
}
