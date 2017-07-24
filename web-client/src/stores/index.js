import Account from './account';

// All our actions are listed here
export const stores = (state = {}) => {
  return {
    account: new Account(state.account),
  };
};

// Initialize actions and state
export default (process.env.BROWSER ? stores(window.__STATE) : {});
