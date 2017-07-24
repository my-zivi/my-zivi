const API = 'https://dev.stiftungswo.ch/api/';

// GET list of all dinosaurs from API
function fetch(url) {
  return fetch(`${API}url`).then(_verifyResponse, _handleError);
}

// GET list of all dinosaurs from API
function getDinoList() {
  return fetch(`${API}regionalcenter`).then(_verifyResponse, _handleError);
}

// GET a dinosaur's detail info from API by ID
function getDino(id) {
  return fetch(`${API}dinosaur/${id}`).then(_verifyResponse, _handleError);
}

// Verify that the fetched response is JSON
function _verifyResponse(res) {
  let contentType = res.headers.get('content-type');

  if (contentType && contentType.indexOf('application/json') !== -1) {
    return res.json();
  } else {
    _handleError({ message: 'Response was not JSON' });
  }
}

// Handle fetch errors
function _handleError(error) {
  console.error('An error occurred:', error);
  throw error;
}

// Export ApiService
const ApiService = { getDinoList, getDino };
export default ApiService;
