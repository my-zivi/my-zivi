import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
import 'popper.js/dist/popper.min';

import $ from 'jquery';

import '../channels';

window.jQuery = $;
window.$ = $;

Rails.start();
Turbolinks.start();

FontAwesome.config.mutateApproach = 'sync';

$(document).on('turbolinks:load', () => $('[data-toggle="popover"]').popover());
