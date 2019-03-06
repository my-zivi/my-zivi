import axios, { AxiosError, AxiosInstance } from 'axios';
import { action, computed, observable, runInAction } from 'mobx';
import { History } from 'history';
import jwt_decode from 'jwt-decode';
import * as Sentry from '@sentry/browser';
import moment from 'moment';

// this will be replaced by a build script, if necessary
const baseUrlOverride = 'BASE_URL';
export const baseUrl = baseUrlOverride.startsWith('http') ? baseUrlOverride : 'http://localhost:48000/api';

export const apiDateFormat = 'YYYY-MM-DD';

const KEY_TOKEN = 'izivi_token';

interface LoginResponse {
  data: {
    token: string;
  };
  message: string;
}

export interface JwtTokenDecoded {
  exp: number;
  iat: number;
  isAdmin: boolean;
  iss: string;
  sub: number;
  details: {
    first_name: string;
    last_name: string;
  };
}

export class ApiStore {
  private _api: AxiosInstance; //tslint:disable-line:variable-name

  @observable
  private _token: string = ''; //tslint:disable-line:variable-name

  @computed
  public get token() {
    return this._token;
  }

  public get api() {
    return this._api;
  }

  constructor(private history: History) {
    this.restoreApiToken();
    this.updateSentryContext();
    this.initializeApiClient(this._token);
  }

  private restoreApiToken() {
    const token = localStorage.getItem(KEY_TOKEN);
    if (token) {
      this._token = token;
    }
  }

  private initializeApiClient(token: string | null) {
    this._api = axios.create({
      baseURL: baseUrl,
    });
    this.setAuthHeader(token);

    this._api.interceptors.response.use(
      response => {
        return response;
      },
      (error: AxiosError) => {
        if (error.response && error.response.status === 401) {
          console.log('Unathorized API access, redirect to login'); //tslint:disable-line:no-console
          this.logout();
        }
        return Promise.reject({ error, messages: error.response ? error.response.data : [] });
      }
    );
  }

  private setAuthHeader(token: string | null) {
    this._api.defaults.headers.Authorization = token ? 'Bearer ' + token : '';
  }

  @action
  public logout(redirect = true): void {
    localStorage.removeItem(KEY_TOKEN);
    this._token = '';
    this.setAuthHeader(null);
    if (redirect) {
      this.history.push('/');
    }
    this.updateSentryContext();
  }

  @action
  public async postLogin(values: { email: string; password: string }) {
    const res = await this._api.post<LoginResponse>('/auth/login', values);
    runInAction(() => {
      this.setToken(res.data.data.token);
      this.updateSentryContext();
    });
  }

  @action
  public async postRegister(values: {
    zdp: string;
    firstname: string;
    lastname: string;
    email: string;
    password: string;
    password_confirm: string;
    community_pw: string;
    newsletter: boolean;
  }) {
    const res = await this._api.post<LoginResponse>('/auth/register', values);
    runInAction(() => {
      this.setToken(res.data.data.token);
      this.updateSentryContext();
    });
  }

  @action
  public async postChangePassword(values: { old_password: string; new_password: string; new_password_2: string }) {
    await this._api.post('/users/change_password', values);
  }

  public async postForgotPassword(email: string) {
    await this._api.post('/auth/forgotPassword', { email });
  }

  private setToken(token: string) {
    this._token = token;
    localStorage.setItem(KEY_TOKEN, token);
    this.setAuthHeader(token);
  }

  private updateSentryContext() {
    if (this.isLoggedIn) {
      Sentry.configureScope(scope =>
        scope.setUser({
          id: String(this.userId),
          full_name: this.meDetail ? `${this.meDetail.first_name} ${this.meDetail.last_name}` : undefined,
        })
      );
    } else {
      Sentry.configureScope(scope => scope.setUser({}));
    }
  }

  @computed
  public get isLoggedIn() {
    return Boolean(this._token) && moment.unix(this.userInfo!.exp).isAfter();
  }

  @computed
  public get isAdmin(): boolean {
    return Boolean(this.userInfo) && Boolean(this.userInfo!.isAdmin);
  }

  @computed
  public get meDetail(): JwtTokenDecoded['details'] | null {
    return this.userInfo ? this.userInfo.details : null;
  }

  @computed
  public get userId(): number | undefined {
    return this.userInfo ? this.userInfo.sub : undefined;
  }

  @computed
  public get userInfo(): JwtTokenDecoded | null {
    return this.token ? jwt_decode(this._token) : null;
  }
}
