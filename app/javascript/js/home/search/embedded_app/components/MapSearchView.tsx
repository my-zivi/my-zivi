import GeoSearch, { MapBounds } from 'js/home/search/embedded_app/components/GeoSearch';
import React, { useState } from 'preact/compat';
import GeoSearchSidePanel from 'js/home/search/embedded_app/components/GeoSearchSidePanel';
import { connectGeoSearch, GeoSearchProvided } from 'react-instantsearch-core';

const MapSearchView = (props: GeoSearchProvided) => {
  const [mapBounds, setMapBounds] = useState<MapBounds>({});

  const onMapMove = (newMapBounds: MapBounds) => {
    setMapBounds(newMapBounds);
  };

  console.log(props.isRefinedWithMap)

  return (
    <div className="geo-search-container">
      <GeoSearch onMapMove={onMapMove} hits={props.hits} currentRefinement={props.currentRefinement}
                 position={props.position} />
      <div className="side-panel-container">
        <GeoSearchSidePanel />
      </div>
    </div>
  );
};

export default connectGeoSearch(MapSearchView);
