import React, { render, h } from 'preact';

export default class EmbeddedApp {
  constructor(selector, RootComponent) {
    this.selector = selector;
    this.RootComponent = RootComponent;
  }

  install() {
    $(document).on('turbolinks:load', () => {
      const container = document.querySelector(this.selector);
      const { RootComponent } = this;

      if (container) {
        render(<RootComponent />, container);
      }
    });
  }
}
