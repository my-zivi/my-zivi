import React, { Component } from 'react';

export default class AdminRestrictedFields extends Component {
  getRoleOptions(result) {
    var options = [];
    let roleNames = ['', 'Admin', 'Zivi'];

    for (let i = 1; i < 3; i++) {
      let isSelected = false;
      if (parseInt(result['role'], 10) === i) {
        isSelected = true;
      }

      options.push(
        <option key={i} value={i} selected={isSelected}>
          {roleNames[i]}
        </option>
      );
    }

    return options;
  }

  getAdminRestrictedFields(self, result) {
    if (self.props.match.params.userid) {
      return (
        <div>
          <div className="form-group">
            <label className="control-label col-sm-3" htmlFor="role">
              Benutzerrolle
            </label>
            <div className="col-sm-9">
              <select id="role" name="role" className="form-control" onChange={e => self.handleChange(e)} value={result.role}>
                {this.getRoleOptions(result)}
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
                value={result.internal_note}
                onInput={e => self.handleChange(e)}
              />
            </div>
          </div>
        </div>
      );
    } else {
      // Don't show these field for own user, since they won't get updated via the /me route
      return null;
    }
  }
}
