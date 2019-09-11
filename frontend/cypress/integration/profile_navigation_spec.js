describe('Profile navigation spec', () => {
  beforeEach(() => {
    cy.login();
    cy.visit('/profile');
  });

  it('can update profile information', () => {
    cy.get('#root .card-body form')
      .contains('Persönliche Informationen');
    cy.get('input[name="first_name"]').clear().type('New first Name');
    cy.get('input[name="last_name"]').clear().type('New last Name');
    cy.get('#root form button').contains('Speichern').click();
    cy.contains('Der Benutzer wurde gespeichert');
  });

  it('it has a services list', () => {
    cy.get('#root table td:nth-child(1)').contains('Gruppeneinsätze, Feldarbeiten');
  });
});
