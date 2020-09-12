import { render, h, Component } from 'preact';
import React from 'preact/compat';

export default class EmbeddedApp<K extends keyof HTMLElementTagNameMap> {
  private readonly selector: K | string;
  private RootComponent: typeof Component;
  private installed: boolean;

  constructor(selector: K | string, RootComponent: typeof Component) {
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

    if (!this.installed && container) {
      const { RootComponent } = this;

      render(<RootComponent />, container);
      this.installed = true;
    }
  }
}
