import GeoSearch from 'js/home/search/embedded_app/components/GeoSearch';
import RefinementsPanel from 'js/home/search/embedded_app/components/RefinementsPanel';
import React from 'preact/compat';

export default () => (
  <div className="geo-search-container">
    <GeoSearch />
    <div className="refinements-panel-container">
      <RefinementsPanel clearFiltersInsideCard={true} />
    </div>
  </div>
);
