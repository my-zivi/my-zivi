import React, { render, h } from 'preact';
import App from './components/App';

$(document).on('turbolinks:load', () => {
  render(<App />, document.querySelector('#planning-app'));
});
