// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import 'core-js/stable';
import 'regenerator-runtime/runtime';

import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';

import $ from 'jquery';

import '@fortawesome/fontawesome-free/js/all.min';
import 'bootstrap/dist/js/bootstrap.min';

import '../channels';
import '../stylesheets/application.scss';
import '../images';

window.jQuery = $;
window.$ = $;

Rails.start();
Turbolinks.start();

FontAwesome.config.mutateApproach = 'sync';
