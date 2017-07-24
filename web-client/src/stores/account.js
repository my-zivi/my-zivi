import { extendObservable } from 'mobx';

/**
 * @class Account
 */
export default class Account {
  constructor(state = {}) {
    extendObservable(
      this,
      {
        email: null,
        token: null,
      },
      state
    );
  }

  isLoggedIn() {
    return this.token !== null;
  }

  logout() {
    request.get('/api/account/logout');
    this.email = null;
    this.token = null;
  }
}
