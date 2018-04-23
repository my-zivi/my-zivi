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
      this.props.label = 'Bemerkung';
      commentField = this.getFormGroup(this.getCommentField(), null, 9, true);
    }

    this.props.label = this.props.valueLabel;
    return (
      <div>
        {this.getFormGroup(this.getMainInputField(), this.getProposalField(), 4)}
        <div class="proposalComment">{commentField}</div>
        <hr />
      </div>
    );
  }

  getMainInputField() {
    let inputType = this.lookForInputType(this.props.inputType);

    return (
      <div class={this.isMainValid() ? '' : 'has-warning'}>
        <input
          type={inputType}
          id={this.props.id}
          name={this.props.id}
          value={this.props.value}
          className="form-control"
          onInput={this.props.onInput}
          readOnly={this.props.disabled}
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
          readonly="true"
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
        value={this.props.commentValue}
        className="form-control"
        onInput={this.props.onInput}
      />
    );
  }
}
