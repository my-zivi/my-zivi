import InputField from './InputField';

export default class InputCheckbox extends InputField {
  render() {
    let isChecked = this.props.value == 1 ? true : false;

    let changeCallback = e => this.props.self.handleChange(e);
    if (this.props.callback) {
      changeCallback = e => this.props.callback(e);
    }

    return this.getFormGroup(
      <input
        type="checkbox"
        id={this.props.id}
        name={this.props.id}
        defaultChecked={isChecked}
        className="form-control"
        onChange={changeCallback}
        disabled={this.props.disabled}
      />,
      null,
      1
    );
  }
}
