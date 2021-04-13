import Turbolinks from 'turbolinks';
import Rails from '@rails/ujs';

import $ from 'jquery';

import '../channels';

window.jQuery = $;
window.$ = $;

Rails.start();
Turbolinks.start();

FontAwesome.config.mutateApproach = 'sync';
