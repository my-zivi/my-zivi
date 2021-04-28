/* eslint-disable @typescript-eslint/no-explicit-any */

const Rails = jest.createMockFromModule('@rails/ujs') as {
  ajax,
  mockError: (error: Error) => void,
  mockResponse: (response: any, forUrl: string) => void,
};

let returnedError = null;
const returnedResponses = {};

Rails.mockError = (error) => {
  returnedError = error;
};

Rails.mockResponse = (response, forUrl) => {
  returnedResponses[forUrl] = response;
};

interface AjaxOptions {
  success: (re: any) => void;
  error: (err: any) => void;
  url: string;
}

Rails.ajax = ({ success, error, url }: AjaxOptions): void => {
  if (returnedError) {
    error(returnedError);
  }
  success(url in returnedResponses ? returnedResponses[url] : null);
};

export default Rails;
