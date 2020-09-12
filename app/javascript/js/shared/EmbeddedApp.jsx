import React, { render, h } from 'preact';

export default class EmbeddedApp {
  constructor(selector, RootComponent) {
    this.selector = selector;
    this.RootComponent = RootComponent;
    this.installed = false;
  }

  install() {
    this.attachToContainer();
    $(document).on('turbolinks:load', () => this.attachToContainer());
  }

  attachToContainer() {
    const container = document.querySelector(this.selector);

    if (container && !this.installed) {
      const { RootComponent } = this;

      render(<RootComponent />, container);
      this.installed = true;
    }
  }
}
