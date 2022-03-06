import Rails from '@rails/ujs';
import * as Turbo from '@hotwired/turbo';
import 'popper.js/dist/popper.min';

import $ from 'jquery';

import '../channels';

window.jQuery = $;
window.$ = $;

Rails.start();
Turbo.start();

FontAwesome.config.mutateApproach = 'sync';

$(document).on('turbo:load', () => $('[data-toggle="popover"]').popover());
