import React from 'react';

const ProfileAdminFields = ({ userRole, internalNote, onChange }) => {
  const roles = [{ id: 0, name: '' }, { id: 1, name: 'Admin' }, { id: 2, name: 'Zivi' }];

  return (
    <div>
      <div className="form-group">
        <label className="control-label col-sm-3" htmlFor="role">
          Benutzerrolle
        </label>
        <div className="col-sm-9">
          <select id="role" name="role" className="form-control" onChange={e => onChange(e)} value={userRole}>
            {roles.map(item => (
              <option key={item.id} value={item.id}>
                {item.name}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="form-group">
        <label className="control-label col-sm-3" htmlFor="internal_comment">
          Interne Bemerkung
        </label>
        <div className="col-sm-9">
          <textarea
            rows="4"
            id="internal_note"
            name="internal_note"
            className="form-control"
            value={internalNote}
            onChange={e => onChange(e)}
          />
        </div>
      </div>
    </div>
  );
};

export default ProfileAdminFields;
