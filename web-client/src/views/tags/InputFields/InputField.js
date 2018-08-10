import React, { Component } from 'react';

export default class InputField extends Component {
  getFormGroup({
    inputField,
    additionalContent = null,
    contentWidth = 8,
    showLabel = true,
    label = this.props.label,
    groupClass = this.props.groupClass,
  }) {
    let divClass = 'col-sm-' + contentWidth;
    if (!showLabel) {
      divClass = 'col';
    }

    return (
      <div className={'form-group ' + groupClass}>
        {showLabel ? (
          <label className="control-label col-sm-3" htmlFor={this.props.id}>
            {label}
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

    return this.getFormGroup({
      inputField: (
        <input
          type={inputType}
          id={this.props.id}
          name={this.props.id}
          value={this.props.value || ''}
          className="form-control"
          onChange={this.props.onInput}
          readOnly={this.props.disabled}
          step={this.props.step}
        />
      ),
    });
  }
}
