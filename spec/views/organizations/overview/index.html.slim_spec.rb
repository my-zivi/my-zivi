# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/overview/index.html.slim', type: :view do
  subject { rendered }

  let(:current_organization_admin) { build(:organization_member) }

  before do
    allow(view).to receive(:current_organization_admin).and_return current_organization_admin
    render
  end

  it 'renders the welcome card' do
    expect(rendered).to include t('organizations.overview.index.welcome_back.title',
                                  name: current_organization_admin.full_name)
  end
end
