import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Component from 'inferno-component';

import { connect } from 'inferno-mobx';

import Card from '../tags/card';

@connect(['accountStore'])
export default class Register extends Component {
  constructor(props) {
    super(props);

    this.state = {
      data: [],
    };
  }

  render() {
    return (
      <div className="page page__register">
        <Card>
          <h1>Register</h1>
          {console.log('----------------------------')}
          {console.log(this.props.accountStore.email)}
          {console.log(this.props.accountStore.token)}
          {console.log(this.props)}
        </Card>
      </div>
    );
  }
}
