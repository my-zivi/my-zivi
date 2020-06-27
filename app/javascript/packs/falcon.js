import Is from 'is_js/is';
import Utils from '@my-zivi/falcon/js/theme/Utils'

window.utils = Utils;
window.is = Is;

import '@my-zivi/falcon/js/theme/navbar.js';
import '@my-zivi/falcon/js/theme/config.dark-mode.js';
import '@my-zivi/falcon/js/theme/bootstrap-navbar.js';
import '@my-zivi/falcon/js/theme/bootstrap-select-menu.js';
import '@my-zivi/falcon/js/theme/detector.js';
import '@my-zivi/falcon/js/theme/forms.js';
import '@my-zivi/falcon/js/theme/stickyfill.js';
import '@my-zivi/falcon/js/theme/stickykit.js';
import '@my-zivi/falcon/js/theme/tooltip.js';
import '@my-zivi/falcon/js/theme/emojionearea.js';

document.addEventListener('load', () => console.log('hello from falcon'));
