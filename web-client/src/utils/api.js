const BASE_URL = 'http://localhost:8000/api/';

// GET list of all dinosaurs from API
function getDinoList() {
  return fetch(`${BASE_URL}regionalcenter`).then(_verifyResponse, _handleError);
}

// GET a dinosaur's detail info from API by ID
function getDino(id) {
  return fetch(`${BASE_URL}dinosaur/${id}`).then(_verifyResponse, _handleError);
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
const ApiService = { getDinoList, getDino, BASE_URL };
export default ApiService;
