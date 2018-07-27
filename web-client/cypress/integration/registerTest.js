describe('Register Test', function() {
  it('should be successful', function() {
    // visit register page
    cy.visit('register');
    cy.get('nav').should('not.contain', 'Profil');

    // fill in form
    cy.get('input[name="zdp"]').type('187187');
    cy.get('input[name="firstname"]').type('Gabriele');
    cy.get('input[name="lastname"]').type('Kohler');
    cy.get('input[name="email"]').type('PaulMuller@cuvox.de');
    cy.get('input[name="password"]').type('Welcome01');
    cy.get('input[name="password_confirm"]').type('Welcome01');
    cy.get('input[name="community_pw"]').type('swoswo');

    // send form and it should have "Profil" now in navigation
    cy.get('button[type="submit"]').click();
    cy.contains('Profil');
  });
});
