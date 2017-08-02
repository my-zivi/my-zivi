import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import { connect } from 'inferno-mobx';

export default class InputField extends Component {
  getFormGroup(inputField, additionalContent = null, contentWidth = 9) {
    return (
      <div className="form-group">
        <label className="control-label col-sm-3" htmlFor={this.props.id}>
          {this.props.label}
        </label>
        <div className={'col-sm-' + contentWidth}>{inputField}</div>
        {additionalContent}
      </div>
    );
  }

  lookForInputType(inputType = 'text') {
    return inputType;
  }

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
        disabled={this.props.disabled}
      />
    );
  }
}
