import React from 'react';
import InputField from './InputField';
import moment from 'moment';

export default class DatePicker extends InputField {
  // picker ref
  picker = null;
  // input ref
  input = null;

  static dateFormat_EN2CH(value) {
    let date = moment(value, 'YYYY-MM-DD');
    return date.isValid() ? date.format('DD.MM.YYYY') : '';
  }

  static dateFormat_CH2EN(value) {
    return moment(value, 'DD.MM.YYYY').format('YYYY-MM-DD');
  }

  componentDidMount() {
    window
      .$(this.picker)
      .datepicker({
        format: 'dd.mm.yyyy',
        autoclose: true,
        startView: 'days',
        todayHighlight: true,
        weekStart: 1,
        language: 'de',
      })
      .on('changeDate', () => this.props.onChange({ target: this.input }));
  }

  componentWillUnmount() {
    window.$(this.picker).datepicker('destroy');
  }

  render() {
    let dateValue = DatePicker.dateFormat_EN2CH(this.props.value);

    let showLabel = true;
    if (this.props.showLabel !== undefined && this.props.showLabel !== '') {
      showLabel = this.props.showLabel;
    }

    // update datepicker itself with the new date
    dateValue && window.$(this.picker).datepicker('update', dateValue);

    return this.getFormGroup({
      inputField: (
        <div
          className={'input-group input-append date ' + (this.props.disabled ? '' : 'datePicker')}
          id="datePicker"
          ref={picker => (this.picker = picker)}
        >
          {/* todo fixme compare this onInput / onChange with original (ability to hand edit the date)*/}
          <input
            autoComplete="off"
            className="form-control"
            data-datepicker
            id={this.props.id}
            name={this.props.name || this.props.id}
            onChange={this.props.onChange}
            ref={input => (this.input = input)}
            readOnly={this.props.disabled}
            type="text"
            value={dateValue}
          />
          <span className="input-group-addon add-on">
            <span className="glyphicon glyphicon-calendar" />
          </span>
        </div>
      ),
      contentWidth: showLabel ? 8 : 12,
    });
  }
}
