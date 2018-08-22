import React from 'react';
import InputField from './InputField';

export default class InputFieldWithProposal extends InputField {
  isMainValid() {
    if (this.props.doValidation) {
      let mainValue = this.props.value;
      let proposalValue = this.props.proposalValue;

      return mainValue.toString() === proposalValue.toString();
    } else {
      return true;
    }
  }

  render() {
    let commentField = null;
    if (this.props.showComment === true) {
      commentField = this.getFormGroup(this.getCommentField(), null, 9, true, 'Bemerkung');
    }

    return (
      <div>
        {this.getFormGroup(this.getMainInputField(), this.getProposalField(), 4, true, this.props.valueLabel)}
        <div className="proposalComment">{commentField}</div>
        <hr />
      </div>
    );
  }

  getMainInputField() {
    let inputType = this.lookForInputType(this.props.inputType);

    return (
      <div className={this.isMainValid() ? '' : 'has-warning'}>
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
      </div>
    );
  }

  getProposalField() {
    let proposalText = 'Vorschlag: ';

    if (this.props.proposalText) {
      proposalText = this.props.proposalText;
    }

    return (
      <div id={'_help' + this.props.id} className="col-sm-5">
        <input
          type="text"
          id={'prop_' + this.props.id}
          value={proposalText + this.props.proposalValue}
          className="form-control"
          readOnly="true"
        />
      </div>
    );
  }

  getCommentField() {
    return (
      <input
        type="text"
        id={this.props.commentId}
        name={this.props.commentId}
        value={this.props.commentValue || ''}
        className="form-control"
        onChange={this.props.onInput}
      />
    );
  }
}
