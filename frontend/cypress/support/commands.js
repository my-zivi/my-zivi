const defaultValues = require('../server/defaults');

Cypress.Commands.add('login', () => {
  localStorage.setItem('izivi_token', defaultValues.authorization_token);
});

Cypress.Commands.add('loginAdmin', () => {
  localStorage.setItem('izivi_token', defaultValues.admin_authorization_token);
});
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This is will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })
