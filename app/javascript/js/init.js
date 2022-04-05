import Rails from '@rails/ujs';
import '@hotwired/turbo-rails';
import 'popper.js/dist/popper.min';

import $ from 'jquery';

import '../channels';

window.jQuery = $;
window.$ = $;

Rails.start();

FontAwesome.config.mutateApproach = 'sync';

$(document).on('turbo:load', () => $('[data-toggle="popover"]').popover());
