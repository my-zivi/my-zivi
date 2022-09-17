import RefinementsInnerPanel from 'js/home/search/embedded_app/components/RefinementsInnerPanel';
import * as React from 'preact/compat';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const GeoSearchSidePanel = () => (
  <>
    <div className="side-panel-actions flex-shrink-0 mb-2">
      <button className="btn btn-translucent-action">Hier Suchen</button>
      <button className="btn btn-translucent-action btn-circle text-info">
        <FontAwesomeIcon icon={['fas', 'info-circle']} />
      </button>
    </div>
    <div className="side-panel-refinements overflow-hidden flex-shrink-1">
      <RefinementsInnerPanel clearFiltersInsideCard={true} />
    </div>
  </>
);

export default GeoSearchSidePanel;
