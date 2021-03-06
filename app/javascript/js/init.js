import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';

import $ from 'jquery';

import '@fortawesome/fontawesome-free/js/all.min';
import 'bootstrap/dist/js/bootstrap.min';

import '../channels';

window.jQuery = $;
window.$ = $;

Rails.start();
Turbolinks.start();

FontAwesome.config.mutateApproach = 'sync';
