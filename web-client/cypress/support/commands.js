// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
Cypress.Commands.add('login', () => {
  cy.request({
    method: 'POST',
    url: 'http://localhost:8000/api/auth/login',
    form: true,
    body: {
      email: 'office@stiftungswo.ch',
      password: 'GutesPasswort',
    },
  }).then(resp => {
    // extract token
    window.localStorage.setItem('jwtToken', resp.body.data.token);
  });
});
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
