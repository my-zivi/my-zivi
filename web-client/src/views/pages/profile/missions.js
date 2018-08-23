import React from 'react';
import { apiURL } from '../../../utils/api';
import Auth from '../../../utils/auth';
import DatePicker from '../../tags/InputFields/DatePicker';
import InputCheckbox from '../../tags/InputFields/InputCheckbox';
import InputFieldWithHelpText from '../../tags/InputFields/InputFieldWithHelpText';
import moment from 'moment-timezone';

export const MissionTable = ({
  addReportSheet,
  calculateMissionDays,
  calculateMissionEndDate,
  deleteMission,
  onChange,
  missions,
  saveMission,
  setReceivedDraft,
  specifications,
  userIdParam,
}) => (
  <div>
    <h3>Einsatzplanung</h3>
    <p>
      Um eine Einsatzplanung zu erfassen, klicke unten auf "Neue Einsatzplanung hinzufügen", wähle ein Pflichtenheft aus und trage Start-
      und Enddatum ein.
      <br />
      Klicke nach dem Erstellen der Einsatzplanung auf "Drucken", um ein PDF zu generieren. Dieses kannst du dann an den Einsatzbetrieb
      schicken.
    </p>
    <p>
      <b>Beachte:</b> Zivi-Einsätze im Naturschutz müssen an einem Montag beginnen und an einem Freitag enden, ausser es handelt sich um
      deinen letzten Zivi Einsatz und du leistest nur noch die verbleibenden Resttage.
    </p>
    <div className={'table-responsive'}>
      <table className={'table table-condensed'}>
        <thead>
          <tr>
            <th>Pflichtenheft</th>
            <th>Start</th>
            <th>Ende</th>
            <th />
            <th />
            <th />
          </tr>
        </thead>
        <tbody>
          {missions.filter(el => el.id !== 'new').map(mission => (
            <MissionRow
              key={mission.id}
              mission={mission}
              specifications={specifications}
              addReportSheet={addReportSheet}
              calculateMissionDays={calculateMissionDays}
              calculateMissionEndDate={calculateMissionEndDate}
              deleteMission={deleteMission}
              onChange={onChange}
              saveMission={saveMission}
              setReceivedDraft={setReceivedDraft}
              userIdParam={userIdParam}
            />
          ))}
        </tbody>
      </table>
    </div>

    {missions.filter(mi => mi.id === 'new').map(mission => (
      <div key={mission.id}>
        <MissionModal
          mission={mission}
          calculateMissionDays={calculateMissionDays}
          calculateMissionEndDate={calculateMissionEndDate}
          onChange={onChange}
          saveMission={saveMission}
          setReceivedDraft={setReceivedDraft}
          specifications={specifications.filter(spec => spec.active)}
        />

        <button className={'btn btn-success'} data-toggle="modal" data-target="#einsatzModal_new">
          Neue Einsatzplanung hinzufügen
        </button>
      </div>
    ))}

    <br />
    <h3>Einsatzverlängerung</h3>
    <p>
      Nach Absprache mit der Einsatzleitung kannst du auch einen Einsatz verlängern. Erfasse dazu eine neue Einsatzplanung, welche als
      Startdatum den Tag nach Einsatzende der vorhergehenden Einsatzplanung hat. Drucke diese Einsatzplanung und lasse sie von der
      Einsatzleitung unterschreiben.
    </p>
    <br />
  </div>
);

const MissionRow = ({
  addReportSheet,
  calculateMissionDays,
  calculateMissionEndDate,
  deleteMission,
  mission,
  onChange,
  saveMission,
  setReceivedDraft,
  specifications,
  userIdParam,
}) => {
  // build name based on specification
  const specification = specifications.find(spec => spec.id.toString() === mission.specification);
  const name = specification ? `${specification.name} (${specification.id})` : 'Einsatz';

  const addButton = Auth.isAdmin() && (
    <button
      data-toggle="popover"
      data-content="Neues Spesenblatt hinzufügen"
      className={'btn btn-xs btn-success'}
      onClick={() => addReportSheet(mission.id)}
      title={''}
    >
      <span className={'glyphicon glyphicon-plus'} aria-hidden={'true'} /> Spesenblatt
    </button>
  );

  const confirmedIcon = (
    <span data-toggle="popover" title="" data-content="Aufgebot erhalten">
      <span className="glyphicon glyphicon-check" style={{ color: 'green' }} />
    </span>
  );

  const deleteButton = Auth.isAdmin() && (
    <button
      className={'btn btn-xs btn-danger'}
      onClick={() => {
        if (window.confirm('Möchten Sie diesen Einsatz wirklich löschen?')) {
          deleteMission(mission.id);
        }
      }}
    >
      <span className={'glyphicon glyphicon-trash'} aria-hidden={'true'} /> Löschen
    </button>
  );

  const draftOpenIcon = (
    <span data-toggle="popover" title="" data-content="Provisorisch">
      <span className="glyphicon glyphicon-unchecked" style={{ color: 'grey' }} />
    </span>
  );

  const feedbackButton = moment().isSameOrAfter(moment(mission.end)) &&
    mission.feedback_done !== 1 &&
    !userIdParam && (
      <a href={`/user_feedback/${mission.id}`} className={'btn btn-xs btn-info'}>
        <span className={'glyphicon glyphicon-list'} aria-hidden={'true'} /> Feedback
      </a>
    );

  return (
    <tr>
      <td>{name}</td>
      <td>{moment(mission.start, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
      <td>{moment(mission.end, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
      <td>{mission === null || mission.draft === null ? draftOpenIcon : confirmedIcon}</td>
      <td>
        <a className={'btn btn-xs'} href={apiURL(`mission/${mission.id}/draft`, {}, true)} target={'_blank'}>
          <span className="glyphicon glyphicon-print" aria-hidden="true" /> Drucken
        </a>
      </td>
      <td>
        <div>
          <button className={'btn btn-xs btn-warning'} data-toggle="modal" data-target={`#einsatzModal_${mission.id}`}>
            <span className={'glyphicon glyphicon-edit'} aria-hidden={'true'} /> Bearbeiten
          </button>
          &nbsp;
          {deleteButton}
          &nbsp;
          {addButton}
          &nbsp;
          {feedbackButton}
          <MissionModal
            mission={mission}
            calculateMissionDays={calculateMissionDays}
            calculateMissionEndDate={calculateMissionEndDate}
            onChange={onChange}
            saveMission={saveMission}
            setReceivedDraft={setReceivedDraft}
            specifications={specifications.filter(spec => spec.active)}
          />
        </div>
      </td>
    </tr>
  );
};

const MissionModal = ({
  calculateMissionDays,
  calculateMissionEndDate,
  mission,
  onChange,
  saveMission,
  setReceivedDraft,
  specifications,
}) => {
  const howerText_Tage =
    'Zeigt dir die Anzahl Tage an, welche für den Einsatz voraussichtlich angerechnet werden. Falls während dem Einsatz Betriebsferien liegen, werden die entsprechenden Tage abgezogen, falls die Dauer zu kurz ist um diese mit Ferientagen kompensieren zu können. Feiertage innerhalb von Betriebsferien gelten auf alle Fälle als Dienstage.';

  const howerText_DayCalculation =
    'Du kannst entweder das gewünschte Enddatum für deinen Einsatz eingeben, und die anrechenbaren Einsatztage werden gerechnet, oder die gewünschten Einsatztage eingeben, und das Enddatum wird berechnet. In beiden Fällen musst du das Startdatum bereits eingegeben haben.';

  const aufgebotErhaltenButton = mission != null &&
    mission.draft == null &&
    Auth.isAdmin() && (
      <button className={'btn btn-primary'} type={'button'} onClick={() => setReceivedDraft(mission.id)}>
        Aufgebot erhalten
      </button>
    );

  return (
    <div id={'einsatzModal_' + (mission ? mission.id : '')} className={'modal fade'} role={'dialog'}>
      <div className={'modal-dialog'}>
        <div className={'modal-content'}>
          <div className={'modal-header'}>
            <button id={'einsatzModalClose'} type={'button'} className={'close'} data-dismiss="modal">
              &times;
            </button>
            <h4 className={'modal-title'}>Zivildiensteinsatz</h4>
          </div>

          <div className={'modal-body'}>
            <div className={'alert alert-info'}>
              <p style={{ textAlign: 'left' }}>
                <b>Hinweis: </b>
                {howerText_DayCalculation}
              </p>
            </div>

            <form
              className={'form-horizontal'}
              onSubmit={e => {
                saveMission(mission.id);
                e.preventDefault();
              }}
            >
              <div className={'form-group'}>
                <label className={'control-label col-sm-3'} htmlFor={`specification_${mission.id}`}>
                  Pflichtenheft
                </label>

                <div className={'col-sm-9'}>
                  <select
                    value={mission.specification}
                    id={`specification_${mission.id}`}
                    name={'specification'}
                    className={'form-control'}
                    onChange={e => onChange(e, mission.id)}
                    required
                  >
                    <option value={'0'} />
                    {specifications.map(spec => (
                      <option key={spec.id} value={spec.id}>
                        {spec.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              <div className={'form-group'}>
                <label className={'control-label col-sm-3'} htmlFor={`mission_type_${mission.id}`}>
                  Einsatzart
                </label>

                <div className={'col-sm-9'}>
                  <select
                    value={mission.mission_type || '0'}
                    id={`mission_type_${mission.id}`}
                    name={'mission_type'}
                    className={'form-control'}
                    onChange={e => onChange(e, mission.id)}
                  >
                    <option value={'0'} />
                    <option value={'1'}>Erster Einsatz</option>
                    <option value={'2'}>Letzter Einsatz</option>
                  </select>
                </div>
              </div>
              <DatePicker
                value={mission.start}
                id={`start_${mission.id}`}
                name={'start'}
                label={'Einsatzbeginn'}
                onChange={e => onChange(e, mission.id)}
              />
              <DatePicker
                value={mission.end}
                id={`end_${mission.id}`}
                name={'end'}
                label={'Einsatzende'}
                onChange={async e => {
                  await onChange(e, mission.id);
                  calculateMissionDays(mission.id);
                }}
              />
              <InputFieldWithHelpText
                value={mission.calculated_mission_days}
                id={`calculated_mission_days_${mission.id}`}
                name={'calculated_mission_days'}
                label={'Einsatztage'}
                popoverText={howerText_Tage}
                onChange={async e => {
                  await onChange(e, mission.id);
                  calculateMissionEndDate(mission.id);
                }}
              />
              <InputCheckbox
                value={mission.first_time}
                id={`first_time_${mission.id}`}
                name={'first_time'}
                label={'Erster SWO Einsatz?'}
                onChange={e => onChange(e, mission.id)}
              />
              <InputCheckbox
                value={mission.long_mission}
                id={`long_mission_${mission.id}`}
                name={'long_mission'}
                label={'Langer Einsatz?'}
                onChange={e => onChange(e, mission.id)}
              />
              <InputCheckbox
                value={mission.probation_period}
                id={`probation_period_${mission.id}`}
                name={'probation_period'}
                label={'Probeeinsatz?'}
                onChange={e => onChange(e, mission.id)}
              />
              <hr />
              <h4>Status</h4>
              {!mission || !mission.draft ? 'Provisorisch' : 'Aufgeboten, Aufgebot erhalten am ' + mission.draft}
              <hr />
              {(!mission || !mission.draft || Auth.isAdmin()) && (
                <button className={'btn btn-primary'} type={'submit'}>
                  Daten speichern
                </button>
              )}
              &nbsp;
              {aufgebotErhaltenButton}
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};
