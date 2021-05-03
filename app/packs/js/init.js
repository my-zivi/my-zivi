import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';

import $ from 'jquery';

import '../channels';

window.jQuery = $;
window.$ = $;

Rails.start();
Turbolinks.start();

FontAwesome.config.mutateApproach = 'sync';
