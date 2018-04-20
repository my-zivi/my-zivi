import { Component } from 'inferno';

export default class AdminRestrictedFields extends Component {
  getRoleOptions(result) {
    var options = [];
    let roleNames = ['', 'Admin', 'Zivi'];

    for (let i = 1; i < 3; i++) {
      let isSelected = false;
      if (parseInt(result['role']) == i) {
        isSelected = true;
      }

      options.push(
        <option value={i} selected={isSelected}>
          {roleNames[i]}
        </option>
      );
    }

    return options;
  }

  getAdminRestrictedFields(self, result) {
    /* Don't show role field for own user */
    let roleFormGroup = [];
    if (self.props.match.params.userid) {
      roleFormGroup.push(
        <div class="form-group">
          <label class="control-label col-sm-3" for="role">
            Benutzerrolle
          </label>
          <div class="col-sm-9">
            <select id="role" name="role" class="form-control" onChange={e => self.handleSelectChange(e)} value={result.role}>
              {this.getRoleOptions(result)}
            </select>
          </div>
        </div>
      );
    }

    return (
      <div>
        <div class="form-group">
          <label class="control-label col-sm-3" for="internal_comment">
            Int. Bemerkung
          </label>
          <div class="col-sm-9">
            <textarea
              rows="4"
              id="internal_note"
              name="internal_note"
              class="form-control"
              value={result.internal_note}
              onInput={e => self.handleTextareaChange(e)}
            />
          </div>
        </div>
        {roleFormGroup}
      </div>
    );
  }
}
