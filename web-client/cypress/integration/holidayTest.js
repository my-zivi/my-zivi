describe('Holiday Test', function() {
  beforeEach(function() {
    cy.login();
  });

  it('should show holidays', function() {
    cy.visit('freeday');
    cy.get('.table')
      .find('tr')
      .should('above.length', 5);
  });
});
