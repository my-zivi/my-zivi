const defaultValues = require('../server/defaults');

describe('Registering', function() {
  after(() => {
    // remove form persistence information from localStorage to enable second run
    setTimeout(() => sessionStorage.removeItem('register-form'), 1200);
  });

  it('can fill out and send register form', function() {
    cy.visit('/');
    cy.get(':nth-child(1) > .nav-link').click();

    // Community Password
    cy.get('input[type="password"].mt-2').type('password');
    cy.get('form > [type="button"]').click();

    // Personal Information
    cy.get('input[name="zdp"]').type('120000');
    cy.get('select[name="regional_center_id"]').select('2');
    cy.get('input[name="first_name"]').type('Peter');
    cy.get('input[name="last_name"]').type('Parker');
    cy.get('input[name="email"]').type('peter.parker@example.com');
    cy.get('input[name="birthday"]').type('12.08.1999');
    cy.get('input[name="password"]').type(defaultValues.password);
    cy.get('input[name="password_confirm"]').type(defaultValues.password);
    cy.get('.container > form > button').contains('Vorwärts').click();

    // Contact Information
    cy.get('input[name="phone"]').type('0791234567');
    cy.get('input[name="address"]').type('Mainstreet 1809');
    cy.get('input[name="city"]').type('Entenhausen');
    cy.get('input[name="zip"]').type('1234');
    cy.get('input[name="hometown"]').type('Gotham');
    cy.get('.container > form > button').contains('Vorwärts').click();

    // Bank and Insurance Information
    cy.get('input[name="bank_iban"]').type('CH93 0076 2011 6238 52957');
    cy.get('input[name="health_insurance"]').type('Ziviinsurance, Zivistrasse 95');
    cy.get('.container > form > button').contains('Registrieren').click();
    cy.contains('Erfolgreich registriert');
    cy.url().should('include', '/profile');
  });
});
