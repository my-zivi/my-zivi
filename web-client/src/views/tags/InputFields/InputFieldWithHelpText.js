import InputField from './InputField';

export default class InputFieldWithHelpText extends InputField {
  render() {
    let inputType = this.lookForInputType(this.props.inputType);

    return this.getFormGroup(
      <input
        type={inputType}
        id={this.props.id}
        name={this.props.id}
        value={this.props.value}
        className="form-control"
        onChange={this.props.onChange}
        readonly={this.props.disabled}
      />,

      <div id={'_help' + this.props.id} className="col-sm-1 hidden-xs">
        <span data-toggle="popover" title={this.props.label} data-content={this.props.popoverText}>
          <span style={{ fontSize: '2em' }} className="glyphicon glyphicon-question-sign" aria-hidden="true" />
        </span>
      </div>,

      8
    );
  }
}
