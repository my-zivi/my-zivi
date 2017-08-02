import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';
import { connect } from 'inferno-mobx';

export default class InputField extends Component {
  render() {
    //TODO type="text" is not displayed
    let defaultType = 'text';
    let inputType = this.props.inputType === 'undefined' ? defaultType : this.props.inputType;

    return (
      <div className="form-group">
        <label className="control-label col-sm-3" htmlFor={this.props.id}>
          {this.props.label}
        </label>
        <div className="col-sm-9">
          <input type={inputType} id={this.props.id} value={this.props.value} className="form-control" disabled={this.props.disabled} />
        </div>
      </div>
    );
  }
}
