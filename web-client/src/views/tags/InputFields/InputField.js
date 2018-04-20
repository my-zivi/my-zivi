import {Component} from 'inferno';

export default class InputField extends Component {
  getFormGroup(inputField, additionalContent = null, contentWidth = 9, showLabel = true) {
    let divClass = 'col-sm-' + contentWidth;
    if (!showLabel) {
      divClass = 'col';
    }

    return (
      <div className="form-group">
        {showLabel ? (
          <label className="control-label col-sm-3" htmlFor={this.props.id}>
            {this.props.label}
          </label>
        ) : null}
        <div className={divClass}>{inputField}</div>
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
        readonly={this.props.disabled}
      />
    );
  }
}
