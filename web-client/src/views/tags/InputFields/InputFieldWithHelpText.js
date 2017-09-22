import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
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
        onChange={e => this.props.self.handleChange(e)}
        readonly={this.props.disabled}
      />,

      <div id={'_help' + this.props.id} className="col-sm-1 hidden-xs">
        <a data-toggle="popover" title={this.props.label} data-content={this.props.popoverText}>
          <span style="font-size:2em;" className="glyphicon glyphicon-question-sign" aria-hidden="true" />
        </a>
      </div>,

      8
    );
  }
}
