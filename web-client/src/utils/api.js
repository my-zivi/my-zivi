import axios from 'axios';
import axiosBuildURL from 'axios/lib/helpers/buildURL';
import Auth from './auth';

//this will be replaced by a build script, if necessary
const baseUrlOverride = 'BASE_URL';
const BASE_URL = baseUrlOverride.startsWith('http') ? baseUrlOverride : 'http://localhost:8000/api/';

export const api = () => {
  return axios.create({
    baseURL: BASE_URL,
    headers: {
      Authorization: 'Bearer ' + Auth.getToken(),
    },
  });
};

export const apiURL = (path, params, auth = false) => {
  if (auth) {
    params.token = Auth.getToken();
  }
  return axiosBuildURL(BASE_URL + path, params);
};
