import L from 'leaflet/dist/leaflet';
import $ from 'jquery';
import { MarkerIcon } from './leaflet_icons';

$(document).on('turbo:load', () => {
  $('[data-leaflet-map]').each((_i, element) => {
    const $element = $(element);
    const coordinates = $element.data('coordinates').split(',').map(parseFloat);
    const map = L.map(element).setView(coordinates, 14);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);

    L.marker(coordinates, { icon: MarkerIcon })
      .addTo(map)
      .bindPopup(`<strong>${($element.data('title'))}</strong>`)
      .openPopup();
  });
});
