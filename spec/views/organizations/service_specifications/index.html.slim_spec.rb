# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/service_specifications/index', type: :view do
  before do
    assign(:organizations_service_specifications, [
             Organizations::ServiceSpecification.create!,
             Organizations::ServiceSpecification.create!
           ])
  end

  it 'renders a list of organizations/service_specifications' do
    render
  end
end
