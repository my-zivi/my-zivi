import L from 'leaflet/dist/leaflet';
import 'leaflet.markercluster/dist/leaflet.markercluster';
import { connectGeoSearch, GeoSearchProvided } from 'react-instantsearch-core';
import * as React from 'preact';
import { MarkerIcon } from 'js/home/leaflet_icons';
import { JobPostingSearchHit } from 'js/home/search/embedded_app/types';
import { MarkerClusterGroup } from 'leaflet';
import { Configure } from 'react-instantsearch-dom';

const centerOfSwitzerland = [46.93109081925106, 8.354415938390526];

class GeoSearchImpl extends React.Component<GeoSearchProvided, Record<string, never>> {
  private readonly mapRef: React.RefObject<HTMLDivElement>;

  private mapInstance: L.Map;
  public markerClusterGroups: MarkerClusterGroup[] = [];
  private userInteractionEnabled = true;

  constructor() {
    super();
    this.mapRef = React.createRef();
  }

  componentDidMount() {
    this.mapInstance = L.map(this.mapRef.current, {
      tap: false,
      renderer: L.canvas(),
    }).setView(centerOfSwitzerland, 8);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; '
        + '<a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors. '
        + 'Search results by <a href="https://algolia.com">Algolia</a>.',
    }).addTo(this.mapInstance);
    this.mapInstance.attributionControl.setPosition('bottomleft');

    // this.mapInstance.on('moveend', () => {
    //   if (this.userInteractionEnabled) {
    //     const ne = this.mapInstance.getBounds().getNorthEast();
    //     const sw = this.mapInstance.getBounds().getSouthWest();
    //
    //     this.props.refine({
    //       northEast: { lat: ne.lat, lng: ne.lng },
    //       southWest: { lat: sw.lat, lng: sw.lng },
    //     });
    //   }
    // });
  }

  componentDidUpdate() {
    const { hits, currentRefinement, position } = this.props;

    this.updateMarkers(hits);

    this.userInteractionEnabled = false;
    if (!currentRefinement && this.markerClusterGroups.length) {
      this.mapInstance.fitBounds(L.featureGroup(this.markerClusterGroups).getBounds(), { animate: false });
    } else if (!currentRefinement) {
      this.mapInstance.setView(position || centerOfSwitzerland, 8, { animate: false });
    }
    this.userInteractionEnabled = true;
  }

  private updateMarkers(ungroupedHits: JobPostingSearchHit[]) {
    const hits = this.groupByLocation(ungroupedHits);

    this.markerClusterGroups.forEach((group) => group.clearLayers());
    /* eslint-disable camelcase */
    this.markerClusterGroups = hits.map((currentMarkers) => {
      const clusterGroup = L.markerClusterGroup();

      currentMarkers.forEach(({ _geoloc, title, brief_description, link }) => {
        const marker = L.marker([_geoloc.lat, _geoloc.lng], { icon: MarkerIcon })
          .bindPopup(`
          <strong>${title}</strong>
          <p>${brief_description}</p>
          <a href="${link}">Details</a>
      `);

        clusterGroup.addLayer(marker);
      });

      this.mapInstance.addLayer(clusterGroup);

      return clusterGroup;
    });
    /* eslint-enable camelcase */
  }

  private groupByLocation(hits: JobPostingSearchHit[]): JobPostingSearchHit[][] {
    const grouped = hits.reduce((acc, hit) => {
      const key = hit.geoloc_hash;
      if (!acc[key]) {
        acc[key] = [hit];
      } else {
        acc[key].push(hit);
      }

      return acc;
    }, {});

    return Object.values(grouped);
  }

  render() {
    return (
      <>
        <Configure hitsPerPage={500} clickAnalytics />
        <div className="leaflet-map" ref={this.mapRef}></div>
      </>
    );
  }
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export default connectGeoSearch(GeoSearchImpl as any);
