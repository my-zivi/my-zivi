import React from 'preact/compat';
import { render, Component } from 'preact';

export default class EmbeddedApp<K extends keyof HTMLElementTagNameMap> {
  private readonly selector: K | string;
  private RootComponent: typeof Component;
  private installed: boolean;

  constructor(selector: K | string, RootComponent: typeof Component) {
    this.selector = selector;
    this.RootComponent = RootComponent;
    this.installed = false;
  }

  install(): void {
    this.attachToContainer();
    $(document).on('turbolinks:load', () => this.attachToContainer());
  }

  attachToContainer(): void {
    const container = document.querySelector(this.selector);

    if (!this.installed && container) {
      const { RootComponent } = this;

      render(<RootComponent />, container);
      this.installed = true;
    }
  }
}
