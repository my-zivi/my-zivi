import Inferno from 'inferno';
import VNodeFlags from 'inferno-vnode-flags';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import ApiService from '../../../utils/api';

export default class AdminRestrictedFields extends Component {
  getRoleOptions(result) {
    var options = [];

    let roleNames = ['', 'Admin', 'Angestellt', 'Zivi'];

    for (let i = 1; i < 4; i++) {
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
    return (
      <div>
        <div class="form-group">
          <label class="control-label col-sm-3" for="internal_comment">
            Int. Bemerkung
          </label>
          <div class="col-sm-9">
            <textarea rows="4" id="internal_note" name="internal_note" class="form-control" onChange={e => self.handleTextareaChange(e)}>
              {result.internal_note}
            </textarea>
          </div>
        </div>
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
      </div>
    );
  }
}
