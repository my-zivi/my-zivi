import { displayError, displaySuccess, displayWarning } from '../utilities/notification';
import { observable, action } from 'mobx';
import { ApiStore, baseUrl } from './apiStore';
import { History } from 'history';
import { Formatter } from 'src/utilities/formatter';
import { buildURL } from '../utilities/helpers';

export class MainStore {
  @observable
  public navOpen = false;

  @observable
  showArchived = false;

  public get api() {
    return this.apiStore.api;
  }

  constructor(private apiStore: ApiStore, public readonly formatter: Formatter, private history: History) {}

  // --- formatting
  public formatDate = this.formatter.formatDate;
  public formatDuration = this.formatter.formatDuration;
  public formatCurrency = this.formatter.formatCurrency;
  public trimString = this.formatter.trimString;

  // --- routing / navigation
  @action
  public navigateTo(path: string): void {
    this.history.push(path);
  }

  // --- notifications
  public displayWarning = displayWarning;
  public displaySuccess = displaySuccess;
  public displayError = displayError;

  public apiURL(path: string, params: object = {}, includeAuth: boolean = true): string {
    return buildURL(baseUrl + '/' + path, {
      ...params,
      token: includeAuth ? this.apiStore.token : undefined,
    });
  }
}
