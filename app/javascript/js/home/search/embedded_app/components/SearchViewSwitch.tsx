import * as React from 'preact/compat';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { IconProp } from '@fortawesome/fontawesome-svg-core';

export enum SearchView {
  Map = 'map',
  Tiles = 'tiles',
}

interface Props {
  activeView: SearchView;
  onChange: (view: SearchView) => void;
}

const AvailableTiles: Record<SearchView, { icon: IconProp, title: string }> = {
  [SearchView.Tiles]: {
    icon: ['fas', 'th'] as IconProp,
    title: MyZivi.translations.search.searchView.tiles,
  },
  [SearchView.Map]: {
    icon: ['fas', 'map'] as IconProp,
    title: MyZivi.translations.search.searchView.map,
  },
};

const SearchViewSwitch: React.FunctionComponent<Props> = ({ activeView, onChange }) => (
    <div className="d-flex justify-content-center">
      <div className="search-view-switch">
        {Object.entries(AvailableTiles).map(([key, { icon, title }]) => (
          <SearchViewSwitchButton
            title={title}
            icon={icon}
            isActive={activeView === key}
            onClick={() => onChange(key as SearchView)}
          />
        ))}
      </div>
    </div>
);

const SearchViewSwitchButton: React.FunctionComponent<{
  title: string,
  icon: IconProp,
  onClick: () => void,
  isActive: boolean
}> = ({ title, icon, isActive, onClick }) => (
  <button type="button" className={`search-view-switch-button ${isActive ? 'active' : ''}`} onClick={onClick}>
    <FontAwesomeIcon icon={icon} className="mr-2" />
    {title}
  </button>
);

export default SearchViewSwitch;
