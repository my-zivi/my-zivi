import React from 'preact/compat';
import { render, ComponentType } from 'preact';
import moment from 'moment';
import $ from 'jquery';

export default class EmbeddedApp<K extends keyof HTMLElementTagNameMap> {
  private readonly selector: K | string;
  private RootComponent: ComponentType;

  constructor(selector: K | string, RootComponent: ComponentType) {
    this.selector = selector;
    this.RootComponent = RootComponent;
  }

  install(): void {
    this.attachToContainer();
    $(document).on('turbolinks:load', () => this.attachToContainer());
  }

  attachToContainer(): void {
    const container = document.querySelector(this.selector);

    if (container) {
      const { RootComponent } = this;

      if ('MyZivi' in window && 'locale' in MyZivi) {
        moment.locale(MyZivi.locale);
      }

      render(<RootComponent />, container);
    }
  }
}
