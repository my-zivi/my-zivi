import InputField from './InputField';
import moment from 'moment-timezone';

export default class DatePicker extends InputField {
  // picker ref
  picker = null;
  // input ref
  input = null;

  static dateFormat_EN2CH(value) {
    return moment(value).format('DD.MM.YYYY');
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
    let dateValue = this.props.value;
    if (dateValue) {
      dateValue = DatePicker.dateFormat_EN2CH(this.props.value);
    } else {
      dateValue = '';
    }

    let showLabel = true;
    if (this.props.showLabel !== undefined && this.props.showLabel !== '') {
      showLabel = this.props.showLabel;
    }

    return this.getFormGroup(
      <div
        className={'input-group input-append date ' + (this.props.disabled ? '' : 'datePicker')}
        id="datePicker"
        ref={picker => (this.picker = picker)}
      >
        {/* todo fixme compare this onInput / onChange with original (ability to hand edit the date)*/}
        <input
          type="text"
          className="form-control"
          id={this.props.id}
          name={this.props.id}
          defaultValue={dateValue}
          ref={input => (this.input = input)}
          readOnly={this.props.disabled}
          autoComplete="off"
        />
        <span className="input-group-addon add-on">
          <span className="glyphicon glyphicon-calendar" />
        </span>
      </div>,
      null,
      showLabel ? 9 : 12,
      showLabel
    );
  }
}
