import { Component } from 'inferno';
import Auth from '../../../utils/auth';
import InputFieldWithHelpText from '../InputFields/InputFieldWithHelpText';
import InputCheckbox from '../InputFields/InputCheckbox';
import DatePicker from '../InputFields/DatePicker';
import Toast from '../../../utils/toast';
import moment from 'moment-timezone';
import { api, apiURL } from '../../../utils/api';

export default class Missions extends Component {
  renderMissions = (self, mission, isAdmin) => {
    let missionKey = mission != null ? mission.id : 'newmission';

    let howerText_Tage =
      'Zeigt dir die Anzahl Tage an welche für den Einsatz voraussichtlich angerechnet werden. Falls während dem Einsatz Betriebsferien liegen werden die entsprechenden Tage abgezogen falls die Dauer zu kurz ist um diese mit Ferientagen kompensieren zu können. Feiertage innerhalb von Betriebsferien gelten auf alle Fälle als Dienstage.';

    var specification_options = [];
    specification_options.push(<option value="" />);
    for (var i = 0; i < self.state.specifications.length; i++) {
      if (self.state.specifications[i].active) {
        specification_options.push(<option value={'' + self.state.specifications[i].id}>{self.state.specifications[i].name}</option>);
      }
    }

    var aufgebotErhaltenButton = [];
    if (mission != null && mission.draft == null && isAdmin) {
      aufgebotErhaltenButton = (
        <button
          className="btn btn-primary"
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
      <div id={'einsatzModal' + (mission != null ? mission.id : '')} className="modal fade" role="dialog">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <button id="einsatzModalClose" type="button" className="close" data-dismiss="modal">
                &times;
              </button>
              <h4 className="modal-title">Zivildiensteinsatz</h4>
            </div>
            <div className="modal-body">
              <form
                className="form-horizontal"
                onSubmit={e => {
                  e.preventDefault();
                  this.saveMission(self, missionKey);
                }}
              >
                <div className="form-group">
                  <label className="control-label col-sm-3" for={missionKey + '_specification'}>
                    Pflichtenheft
                  </label>
                  <div className="col-sm-9">
                    <select
                      value={'' + self.state['result'][missionKey + '_specification']}
                      id={missionKey + '_specification'}
                      name={missionKey + '_specification'}
                      className="form-control"
                      onChange={e => self.handleChange(e)}
                      required
                    >
                      {specification_options}
                    </select>
                  </div>
                </div>
                <div className="form-group">
                  <label className="control-label col-sm-3" for="newmission_mission_type">
                    Einsatzart
                  </label>
                  <div className="col-sm-9">
                    <select
                      value={'' + self.state['result'][missionKey + '_mission_type']}
                      id={missionKey + '_mission_type'}
                      name={missionKey + '_mission_type'}
                      className="form-control"
                      onChange={e => self.handleChange(e)}
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
                  onChange={e => {
                    self.handleDateChange(e, self);
                    this.getMissionDays(self, missionKey);
                  }}
                />
                <DatePicker
                  value={self.state['result'][missionKey + '_end']}
                  id={missionKey + '_end'}
                  label="Einsatzende"
                  onChange={e => {
                    self.handleDateChange(e, self);
                    this.getMissionDays(self, missionKey);
                  }}
                />
                <InputFieldWithHelpText
                  value={self.state['result'][missionKey + '_days']}
                  id={missionKey + '_days'}
                  label="Tage"
                  popoverText={howerText_Tage}
                  onChange={e => {
                    self.handleChange(e, self);
                    this.calculateMissionEndDate(e, self, missionKey);
                  }}
                />
                <InputCheckbox
                  value={self.state['result'][missionKey + '_first_time']}
                  id={missionKey + '_first_time'}
                  label="Erster SWO Einsatz"
                  onChange={self.handleChange.bind(self)}
                />
                <InputCheckbox
                  value={self.state['result'][missionKey + '_long_mission']}
                  id={missionKey + '_long_mission'}
                  label="Langer Einsatz oder Teil davon"
                  onChange={e => {
                    self.handleChange(e);
                    this.getMissionDays(self, missionKey);
                  }}
                />
                <InputCheckbox
                  value={self.state['result'][missionKey + '_probation_period']}
                  id={missionKey + '_probation_period'}
                  label="Probeeinsatz"
                  onChange={self.handleChange.bind(self)}
                />
                <hr />
                <h4>Status</h4>
                {mission == null || mission.draft == null ? 'Provisorisch' : 'Aufgeboten, Aufgebot erhalten am ' + mission.draft}
                <hr />
                {mission == null || mission.draft == null || Auth.isAdmin() ? (
                  <button className="btn btn-primary" type="submit">
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
    api()
      .post(`mission/${missionKey}/receivedDraft`)
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
      <span data-toggle="popover" title="" data-content="Aufgebot erhalten">
        <span className="glyphicon glyphicon-check" style={{ color: 'green' }} />
      </span>
    );

    let draftOpenIcon = (
      <span data-toggle="popover" title="" data-content="Provisorisch">
        <span className="glyphicon glyphicon-unchecked" style={{ color: 'grey' }} />
      </span>
    );

    var missions = [];
    if (self.state.result.missions != null) {
      var m = self.state.result.missions;
      for (var i = 0; i < m.length; i++) {
        var name = m[i].specification;

        for (var s = 0; s < self.state.specifications.length; s++) {
          if (m[i].specification === self.state.specifications[s].id) {
            name = name + ' ' + self.state.specifications[s].name;
            break;
          }
        }

        let curMission = m[i];
        var deleteButton = [];
        var addButton = [];

        if (Auth.isAdmin()) {
          deleteButton = (
            <button
              className="btn btn-xs btn-danger"
              onClick={() => {
                if (window.confirm('Möchten Sie diesen Einsatz wirklich löschen?')) {
                  self.missionTag.deleteMission(self, curMission);
                }
              }}
            >
              <span className="glyphicon glyphicon-trash" aria-hidden="true" /> Löschen
            </button>
          );
          addButton = (
            <button
              data-toggle="popover"
              data-content="Neues Meldeblatt hinzufügen"
              className="btn btn-xs btn-success"
              onClick={() => {
                self.addReportSheet(curMission.id);
              }}
              title=""
            >
              <span className="glyphicon glyphicon-plus" aria-hidden="true" /> Meldeblatt
            </button>
          );
        }

        var feedbackButton = [];

        if (
          moment().isSameOrAfter(moment(m[i].end)) &&
          +m[i].feedback_done !== 1 &&
          self.props.match.params.userid === undefined && // Only allow feedbacks for own user
          curMission.draft != null // Only allow feedbacks for confirmed missions
        ) {
          feedbackButton = (
            <a href={'/user_feedback/' + m[i].id} className="btn btn-xs btn-info">
              <span className="glyphicon glyphicon-list" aria-hidden="true" /> Feedback
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
              <a className="btn btn-xs" href={apiURL(`mission/${curMission.id}/draft`, {}, true)} target="_blank">
                <span className="glyphicon glyphicon-print" aria-hidden="true" /> Drucken
              </a>
            </td>
            <td>
              <div>
                <button className="btn btn-xs btn-warning" data-toggle="modal" data-target={'#einsatzModal' + m[i].id}>
                  <span className="glyphicon glyphicon-edit" aria-hidden="true" /> Bearbeiten
                </button>&nbsp;
                {deleteButton}&nbsp;
                {addButton}&nbsp;
                {feedbackButton}
              </div>
            </td>
          </tr>
        );
        missions.push(this.renderMissions(self, m[i], Auth.isAdmin()));
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

    if (moment(newMission['start']).isoWeekday() !== 1 && +newMission['probation_period'] !== 1) {
      Toast.showError('Falscher Einsatzbeginn', 'Erster Einsatztag muss zwingend ein Montag sein!', null, null);
      return;
    }

    if (moment(newMission['end']).isoWeekday() !== 5 && +newMission['mission_type'] !== 2 && +newMission['probation_period'] !== 1) {
      Toast.showError(
        'Falsches Einsatzende',
        'Letzter Einsatztag muss zwingend ein Freitag sein! (Ausnahme: letzter Einsatz)',
        null,
        self.context
      );
      return;
    }

    if (!moment(newMission['start']).isSameOrBefore(moment(newMission['end']))) {
      Toast.showError('Falsches Einsatzdauer', 'Erster Einsatztag nach dem letzten Einsatztag', null, null);
      return;
    }

    self.setState({ loading: true, error: null });
    if (missionKey === 'newmission') {
      api()
        .post('mission', newMission)
        .then(response => {
          Toast.showSuccess('Speichern erfolgreich', 'Neuer Einsatz konnte gespeichert werden');
          window.$('[data-dismiss=modal]').trigger({ type: 'click' });
          self.getUser();
        })
        .catch(error => {
          self.setState({ loading: false, error: null });
          Toast.showError('Speichern fehlgeschlagen', 'Neuer Einsatz konnte nicht gespeichert werden', error, path =>
            self.props.history.push(path)
          );
        });
    } else {
      api()
        .put('mission/' + missionKey, newMission)
        .then(response => {
          Toast.showSuccess('Speichern erfolgreich', 'Einsatz konnte gespeichert werden');
          window.$('[data-dismiss=modal]').trigger({ type: 'click' });
          self.getUser();
          self.getReportSheets();
        })
        .catch(error => {
          self.setState({ loading: false, error: null });
          Toast.showError('Speichern fehlgeschlagen', 'Einsatz konnte nicht gespeichert werden', error, path =>
            self.props.history.push(path)
          );
        });
    }
  }

  deleteMission(self, mission) {
    self.setState({ loading: true, error: null });
    api()
      .delete('mission/' + mission.id)
      .then(response => {
        Toast.showSuccess('Löschen erfolgreich', 'Einsatz konnte gelöscht werden');
        self.getUser();
        self.getReportSheets();
      })
      .catch(error => {
        Toast.showError('Löschen fehlgeschlagen', 'Einsatz konnte nicht gelöscht werden', error, path => self.props.history.push(path));
        self.setState({ loading: false, error: null });
      });
  }

  calculateMissionEndDate(e, self, missionKey) {
    self.setState({
      result: {
        ...self.state.result,
        [e.target.name]: e.target.value, // update days
      },
    });
    let startDate = self.state['result'][missionKey + '_start'];

    if (e.target.value && e.target.value > 0 && startDate) {
      let long_mission = self.state.result[missionKey + '_long_mission'];
      if (!long_mission) {
        long_mission = false;
      }

      api()
        .get('diensttageEndDate', { params: { start: startDate, days: self.state.result[missionKey + '_days'], long_mission } })
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
      api()
        .get('diensttage', {
          params: {
            start: self.state.result[missionKey + '_start'],
            end: self.state.result[missionKey + '_end'],
            long_mission,
          },
        })
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
