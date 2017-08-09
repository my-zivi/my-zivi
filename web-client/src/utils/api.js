const BASE_URL = 'http://localhost:8000/api/';

// Is user logged in?
const isLoggedIn = () => {
  if (localStorage.getItem('jwtToken') !== null) {
    return true;
  } else {
    return false;
  }
};

// Is user an administrator?
export const isAdmin = () => {
  if (isLoggedIn()) {
    const jwtDecode = require('jwt-decode');
    const decodedToken = jwtDecode(localStorage.getItem('jwtToken'));
    return decodedToken.isAdmin;
  }
  return false;
};

// Verify that the fetched response is JSON
export function _verifyResponse(res) {
  let contentType = res.headers.get('content-type');

  if (contentType && contentType.indexOf('application/json') !== -1) {
    return res.json();
  } else {
    _handleError({ message: 'Response was not JSON' });
  }
}

const ApiService = { BASE_URL, isLoggedIn, isAdmin };
export default ApiService;
