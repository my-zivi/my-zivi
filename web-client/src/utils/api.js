const BASE_URL = 'http://localhost:8000/api/';
const jwtDecode = require('jwt-decode');
const decodedToken = jwtDecode(localStorage.getItem('jwtToken'));

// Is user logged in?
const isLoggedIn = () => {
  if (localStorage.getItem('jwtToken') !== null) {
    return true;
  } else {
    return false;
  }
};

// Is user an administrator?
const isAdmin = () => {
  if (isLoggedIn()) {
    return decodedToken.isAdmin;
  }
  return false;
};

// Get logged in user id
const getUserId = () => {
  if (isLoggedIn()) {
    return decodedToken.sub;
  }
};

// Verify that the fetched response is JSON
function _verifyResponse(res) {
  let contentType = res.headers.get('content-type');

  if (contentType && contentType.indexOf('application/json') !== -1) {
    return res.json();
  } else {
    _handleError({ message: 'Response was not JSON' });
  }
}

const ApiService = { BASE_URL, isLoggedIn, isAdmin, getUserId };
export default ApiService;
