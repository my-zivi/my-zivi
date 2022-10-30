import * as React from 'preact/compat';
import GeoSearch from './GeoSearch';
import { mountInstantSearchClient } from '../../../../../../../jest/utils';

describe('GeoSearch', () => {
  it('renders a map', () => {
    const wrapper = mountInstantSearchClient(<GeoSearch />, 'GeoSearchImpl');
    expect(wrapper.find('.leaflet-map')).toHaveLength(1);
  });
});
