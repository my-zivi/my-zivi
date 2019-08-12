const defaultValues = require('../server/defaults');

describe('Login', () => {
  it('can log a user in', () => {
    cy.visit('/login');
    cy.get('input[name="email"]').type('peter.parker@example.com');
    cy.get('input[name="password"]').type(defaultValues.password);
    cy.get('form > button').contains('Anmelden').click();
    cy.url().should('include', '/profile');
    cy.contains('Profil');
  });

  it('keeps a user logged in when the token is present', () => {
    cy.login();
    cy.visit('/profile');
    cy.url().should('include', '/profile');
    cy.contains('Profil');
    cy.wait(10);
    cy.get('.iziToast-message').should('not.exist');
  });
});
