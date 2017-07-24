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

  login(params) {
    axios
      .post('https://dev.stiftungswo.ch/api/auth/login', { email: 'office@stiftungswo.ch', password: '1234' })
      .then(response => {
        console.log(response);
        console.log(response.data.message);
        console.log(response.data.data.token);
        this.email = email;
        this.token = response.data.data.token;
        localStorage.setItem('jwtToken', response.data.data.token);
      })
      .catch(error => {
        console.log('LoginAPI failed!');
        console.log(error); // to be verified also: error.data.error.message
      });
  }

  logout() {
    request.get('/api/account/logout');
    this.email = null;
    this.token = null;
  }
}
