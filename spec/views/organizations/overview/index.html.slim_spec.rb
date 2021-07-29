# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/overview/index.html.slim', type: :view do
  subject { rendered }

  let(:current_organization_admin) { create(:organization_member) }
  let(:service) { create(:service) }
  let(:expected_strings) do
    [
      current_organization_admin.organization.name,
      t('organizations.overview.index.cards.welcome_back.title', name: current_organization_admin.full_name),
      t('organizations.overview.index.cards.phone_lists.title'),
      t('organizations.overview.index.cards.phone_lists.links.current_week'),
      t('organizations.overview.index.cards.phone_lists.links.current_month'),
      t('organizations.overview.index.cards.active_services.title'),
      t('organizations.overview.index.cards.active_services.link'),
      '2',
      t('organizations.overview.index.cards.editable_expense_sheets.title'),
      t('organizations.overview.index.cards.editable_expense_sheets.link'),
      '0',
      service.civil_servant.full_name,
      organizations_civil_servant_service_path(service.civil_servant, service)
    ]
  end

  before do
    create_pair(:civil_servant, :full, :with_service, organization: current_organization_admin.organization)
    assign(:services, [service])

    sign_in current_organization_admin.user

    without_partial_double_verification do
      allow(view).to receive(:current_organization_admin).and_return current_organization_admin
      allow(view).to receive(:current_organization).and_return current_organization_admin.organization
    end

    render
  end

  it 'renders all the expected card strings' do
    expect(rendered).to include(*expected_strings)
  end
end
