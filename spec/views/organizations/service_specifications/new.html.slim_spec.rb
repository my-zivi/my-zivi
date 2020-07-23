# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/service_specifications/new', type: :view do
  let(:service_specification) { ServiceSpecification.new }
  let(:current_organization_admin) { build(:organization_member) }

  before do
    assign(:service_specification, service_specification)
    allow(view).to receive(:current_organization_admin).and_return current_organization_admin
  end

  it_behaves_like 'renders service specification form' do
    let(:form_action) { organizations_service_specifications_path }
  end
end
