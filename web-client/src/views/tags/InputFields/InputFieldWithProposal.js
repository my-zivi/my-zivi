import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import InputField from './InputField';

export default class InputFieldWithProposal extends InputField {
  validateMainField() {
    if (this.props.doValidation !== undefined && this.props.doValidation == true) {
      let mainValue = $('#' + this.props.id).val();
      let proposalValue = this.props.proposalValue;

      if (mainValue == proposalValue) {
        $('#' + this.props.id)
          .parent()
          .removeClass('has-warning');
      } else {
        $('#' + this.props.id)
          .parent()
          .addClass('has-warning');
      }
    }
  }

  componentDidMount() {
    this.validateMainField();
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
      <input
        type={inputType}
        id={this.props.id}
        name={this.props.id}
        value={this.props.value}
        className="form-control"
        onChange={e => {
          this.validateMainField();
          this.props.self.handleChange(e);
        }}
        disabled={this.props.disabled}
      />
    );
  }

  getProposalField() {
    let proposalText = 'Vorschlag: ';

    if (this.props.proposalText !== undefined && this.props.proposalText != '') {
      proposalText = this.props.proposalText;
    }

    return (
      <div id={'_help' + this.props.id} className="col-sm-5">
        <input
          type="text"
          id={'prop_' + this.props.id}
          value={proposalText + this.props.proposalValue}
          className="form-control"
          disabled="true"
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
        onChange={e => this.props.self.handleChange(e)}
      />
    );
  }
}
