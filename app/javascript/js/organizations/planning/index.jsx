import React, { render, h } from 'preact';
import App from './components/App';

$(document).on('turbolinks:load', () => {
  const container = document.querySelector('#planning-app');
  if (container) {
    render(<App />, container);
  }
});
