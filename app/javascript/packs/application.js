// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import 'core-js/stable';
import 'regenerator-runtime/runtime';

import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';

import 'select2';
import $ from 'jquery';

import '@fortawesome/fontawesome-free/js/all.min';
import 'bootstrap/dist/js/bootstrap.min';

import '../channels';
import '../stylessheets/application.scss';
import '../images';

Rails.start();
Turbolinks.start();

window.jQuery = $;
window.$ = $;

FontAwesome.config.mutateApproach = 'sync';

$(document).on('turbolinks:load', () => {
  $('[data-typeahead-select]').each((_i, element) => {
    const $select = $(element);
    const options = $.extend({}, $select.data('options'));
    $select.select2(options);
  });
});
