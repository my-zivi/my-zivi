import { History } from 'history';
import { action, observable } from 'mobx';
import { Formatter } from '../utilities/formatter';
import { buildURL } from '../utilities/helpers';
import { displayError, displaySuccess, displayWarning } from '../utilities/notification';
import { ApiStore, baseUrl } from './apiStore';

export class MainStore {
  get api() {
    return this.apiStore.api;
  }

  @observable
  navOpen = false;

  @observable
  showArchived = false;

  // --- formatting
  formatDate = this.formatter.formatDate;
  formatDuration = this.formatter.formatDuration;
  formatCurrency = this.formatter.formatCurrency;
  trimString = this.formatter.trimString;

  // --- notifications
  displayWarning = displayWarning;
  displaySuccess = displaySuccess;
  displayError = displayError;

  constructor(private apiStore: ApiStore, readonly formatter: Formatter, private history: History) {}

  // --- routing / navigation
  @action
  navigateTo(path: string): void {
    this.history.push(path);
  }

  apiURL(path: string, params: object = {}, includeAuth: boolean = true): string {
    return buildURL(baseUrl + '/' + path, {
      ...params,
      token: includeAuth ? this.apiStore.token : undefined,
    });
  }

  validateIBAN(value: string) {
    const regex = new RegExp('^CH\\d{2,2}\\s{0,1}(\\w{4,4}\\s{0,1}){4,7}\\w{0,2}$', 'g');
    return regex.test(value);
  }

  isAdmin() {
    return this.apiStore.isAdmin;
  }
}
