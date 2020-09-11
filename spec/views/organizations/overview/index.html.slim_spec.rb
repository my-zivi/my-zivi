# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/overview/index.html.slim', type: :view do
  subject { rendered }

  let(:current_organization_admin) { create(:organization_member) }
  let(:expected_strings) do
    [
        t('organizations.overview.index.welcome_back.title', name: current_organization_admin.full_name),
        t('organizations.overview.index.phone_lists.title'),
        t('organizations.overview.index.phone_lists.title'),
        t('organizations.overview.index.phone_lists.current_week'),
        t('organizations.overview.index.phone_lists.current_month'),
        t('organizations.overview.index.active_civil_servants'),
        t('base.organizations.navbar.civil_servants'),
        '2'
    ]
  end

  before do
    create_pair :civil_servant, :full, :with_service, { organization: current_organization_admin.organization }

    allow(view).to receive(:current_organization_admin).and_return current_organization_admin

    render
  end

  it 'renders all the expected card strings' do
    expect(rendered).to include *expected_strings
  end
end
