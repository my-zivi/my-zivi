import React from 'preact/compat';
import { render, ComponentType } from 'preact';
import moment from 'moment';

export default class EmbeddedApp<K extends keyof HTMLElementTagNameMap> {
  private readonly selector: K | string;
  private RootComponent: ComponentType;
  private installed: boolean;

  constructor(selector: K | string, RootComponent: ComponentType) {
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

      moment.locale('de');

      render(<RootComponent />, container);
      this.installed = true;
    }
  }
}
