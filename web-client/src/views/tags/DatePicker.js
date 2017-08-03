import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import { connect } from 'inferno-mobx';
import InputField from '../tags/InputField';

export default class DatePicker extends InputField {
  static dateFormat_EN2CH(value) {
    let dateArray = value.split('-');
    return dateArray[2] + '.' + dateArray[1] + '.' + dateArray[0];
  }

  static dateFormat_CH2EN(value) {
    let dateArray = value.split('.');
    return dateArray[2] + '-' + dateArray[1] + '-' + dateArray[0];
  }

  render() {
    let dateValue = this.props.value;
    if (this.props.value === undefined || parseInt(this.props.value) == 0) {
      dateValue = null;
    } else {
      dateValue = DatePicker.dateFormat_EN2CH(this.props.value);
    }

    return this.getFormGroup(
      <div class="input-group input-append date datePicker" id="datePicker">
        <input
          type="text"
          class="form-control"
          id={this.props.id}
          name={this.props.id}
          value={dateValue}
          onChange={e => this.props.self.handleDateChange(e)}
        />
        <span class="input-group-addon add-on">
          <span class="glyphicon glyphicon-calendar" />
        </span>
      </div>
    );
  }
}
