import React from 'react';
import { apiURL } from '../../../utils/api';
import Auth from '../../../utils/auth';
import { Link } from 'react-router-dom';
import moment from 'moment-timezone';

export const ReportSheets = ({ reportSheets }) => {
  return (
    <div>
      <h3>Spesenblätter</h3>

      <table className={'table table-condensed'}>
        <thead>
          <tr>
            <th>Von</th>
            <th>Bis</th>
            <th>Anzahl Tage</th>
            <th>Status</th>
            <th />
            {Auth.isAdmin() && <th />}
          </tr>
        </thead>

        <tbody>
          {reportSheets.map(rsheet => (
            <tr key={rsheet.id}>
              <td>{moment(rsheet.start, 'YYYY-MM-DD').format('DD.MM.YYYY')}</td>
              <td>{moment(rsheet.end, 'YYYY-MM-DD').format('DD.MM.YYYY')} </td>
              <td> {rsheet.days} </td>
              <td>
                {rsheet.state > 0 ? (
                  rsheet.state === 3 ? (
                    <span data-toggle="popover" title={''} data-content="Erledigt">
                      <span className={'glyphicon glyphicon-ok'} style={{ color: 'green' }} />
                    </span>
                  ) : (
                    <span data-toggle="popover" title={''} data-content="In Bearbeitung">
                      <span className={'glyphicon glyphicon-hourglass'} style={{ color: 'orange' }} />
                    </span>
                  )
                ) : (
                  <span data-toggle="popover" title={''} data-content="Noch nicht fällig">
                    <span className={'glyphicon glyphicon-time'} />
                  </span>
                )}
              </td>
              <td>
                {rsheet.state === 3 && (
                  <a
                    name={'showReportSheet'}
                    className={'btn btn-xs btn-link'}
                    href={apiURL('pdf/zivireportsheet', { reportSheetId: rsheet.id }, true)}
                    target={'_blank'}
                  >
                    <span className={'glyphicon glyphicon-print'} aria-hidden={'true'} /> Drucken
                  </a>
                )}
              </td>
              {Auth.isAdmin() && (
                <td>
                  <Link to={'/expense/' + rsheet.id} className={'btn btn-link btn-xs btn-warning'} name={'editReportSheet'}>
                    <span className={'glyphicon glyphicon-edit'} aria-hidden={'true'} /> Bearbeiten
                  </Link>
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};
