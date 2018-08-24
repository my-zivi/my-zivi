import React, { Component } from 'react';
import { api } from '../../../utils/api';

export default class RegionalCenters extends Component {
  constructor(props) {
    super(props);

    this.state = {
      regionalCenters: [],
    };
  }

  componentDidMount() {
    this.getRegionalCenters();
  }

  getRegionalCenters() {
    this.props.onLoading('regional_centers', true);

    api()
      .get('regionalcenter')
      .then(response => {
        this.setState({
          regionalCenters: response.data,
        });
        this.props.onLoading('regional_centers', false);
      })
      .catch(error => {
        this.props.onError(error);
      });
  }

  render() {
    const { regionalCenters } = this.state;
    const { selectedCenter } = this.props;

    return (
      <div className={'form-group'}>
        <label className={'control-label col-sm-3'} htmlFor={'regional_center'}>
          Regionalzentrum
        </label>

        <div className={'col-sm-8'}>
          <select
            id={'regional_center'}
            name={'regional_center'}
            className={'form-control'}
            onChange={e => this.props.onChange(e)}
            value={selectedCenter ? +selectedCenter : 0}
          >
            <option value={''} />
            {regionalCenters.map(({ id, name }) => (
              <option key={id} value={id}>
                {name}
              </option>
            ))}
          </select>
        </div>
      </div>
    );
  }
}
