import Inferno from 'inferno';
import { Link } from 'inferno-router';
import Card from '../tags/card';
import axios from 'axios';
import Component from 'inferno-component';
import ApiService from '../../utils/api';

export default class MissionOverview extends Component {
  constructor(props) {
    super(props);

    this.state = {};
  }

  render() {
    return (
      <div className="page page__mission_overview">
        <Card>
          <h1>Einsatzübersicht</h1>
        </Card>
      </div>
    );
  }
}
