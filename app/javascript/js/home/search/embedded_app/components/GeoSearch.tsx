import L from 'leaflet/dist/leaflet';
import { connectGeoSearch, GeoSearchProvided } from 'react-instantsearch-core';
import * as React from 'preact';
import iconUrl from 'leaflet/dist/images/marker-icon.png';
import iconRetinaUrl from 'leaflet/dist/images/marker-icon-2x.png';
import shadowUrl from 'leaflet/dist/images/marker-shadow.png';

const centerOfSwitzerland = [46.93109081925106, 8.354415938390526];
const icon = new L.Icon({
  iconRetinaUrl,
  shadowUrl,
  iconUrl,
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  tooltipAnchor: [16, -28],
  shadowSize: [41, 41],
});

class GeoSearch extends React.Component<GeoSearchProvided, Record<string, never>> {
  private readonly mapRef: React.RefObject<HTMLDivElement>;

  private mapInstance: L.Map;
  private markers: L.Marker[] = [];
  private userInteractionEnabled = true;

  constructor() {
    super();
    this.mapRef = React.createRef();
  }

  componentDidMount() {
    // const { refine } = this.props;
    this.mapInstance = L.map(this.mapRef.current).setView(centerOfSwitzerland, 8);

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
    //     refine({
    //       northEast: { lat: ne.lat, lng: ne.lng },
    //       southWest: { lat: sw.lat, lng: sw.lng },
    //     });
    //   }
    // });
  }

  componentDidUpdate() {
    const { hits, currentRefinement, position } = this.props;

    this.markers.forEach((marker) => marker.remove());
    this.markers = hits.map(({ _geoloc }) => L.marker([_geoloc.lat, _geoloc.lng], { icon })
      .addTo(this.mapInstance));

    this.userInteractionEnabled = false;
    if (!currentRefinement && this.markers.length) {
      this.mapInstance.fitBounds(L.featureGroup(this.markers).getBounds(), {
        animate: false,
      });
    } else if (!currentRefinement) {
      this.mapInstance.setView(
        position || {
          lat: 48.864716,
          lng: 2.349014,
        },
        12,
        {
          animate: false,
        },
      );
    }
    this.userInteractionEnabled = true;
  }

  render() {
    return (
      <div className="leaflet-map" ref={this.mapRef}></div>
    );
  }
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export default connectGeoSearch(GeoSearch as any);
