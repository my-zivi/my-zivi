describe('ExpenseSheet form spec', () => {
  beforeEach(() => {
    cy.loginAdmin();
    cy.visit('/expense_sheets/1');
  });

  it('should have the right status badge', function () {
    cy.get('.ml-3').contains('Offen')
  });

  it('should have correct hints', () => {
    cy.get(':nth-child(7) > .col-md-9 > .input-group > .input-group-append > .input-group-text').contains('Vorschlag: 20 Tage');
    cy.get(':nth-child(8) > .col-md-9 > .input-group > .input-group-append > .input-group-text').contains('Vorschlag: 6 Tage');
    cy.get(':nth-child(9) > .col-md-9 > .input-group > .input-group-append > .input-group-text').contains('Übriges Guthaben: 5 Tage');
    cy.get(':nth-child(11) > .col-md-9 > .input-group > .input-group-append > .input-group-text').contains('Vorschlag: 0 Tage');
    cy.get(':nth-child(12) > .col-md-9 > .input-group > .input-group-append > .input-group-text').contains('Vorschlag: 0 Tage');
    cy.get(':nth-child(3) > .input-group-text').contains('Vorschlag: 59.80 CHF');
  });
});
