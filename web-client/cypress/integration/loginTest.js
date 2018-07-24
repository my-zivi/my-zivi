describe('Login Test', function() {
  it('should fail', function() {
    // visit login page
    cy.visit('login');

    // fill out with wrong login data
    cy.get('input[name="email"]').type('example@wrongdomain.com');
    cy.get('input[name="password"]').type('wrong password');
    cy.get('button[type="submit"]').click();

    cy.contains('E-Mail oder Passwort falsch!');
  });

  it('should be successful', function() {
    // visit login page
    cy.visit('login').contains('Registrieren');

    // fill out the form with correct data
    cy.get('input[name="email"]').type('office@stiftungswo.ch');
    cy.get('input[name="password"]').type('GutesPasswort');
    cy.get('button[type="submit"]').click();

    cy.contains('Mitarbeiterliste');
  });
});
