import L from 'leaflet/dist/leaflet';
import $ from 'jquery';
import iconUrl from 'leaflet/dist/images/marker-icon.png';
import iconRetinaUrl from 'leaflet/dist/images/marker-icon-2x.png';
import shadowUrl from 'leaflet/dist/images/marker-shadow.png';

$(document).on('turbo:load', () => {
  $('[data-leaflet-map]').each((_i, element) => {
    const $element = $(element);
    const coordinates = $element.data('coordinates').split(',').map(parseFloat);
    const map = L.map(element).setView(coordinates, 14);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);

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

    L.marker(coordinates, { icon })
      .addTo(map)
      .bindPopup(`<strong>${($element.data('title'))}</strong>`)
      .openPopup();
  });
});
