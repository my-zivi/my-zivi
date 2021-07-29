# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations Portal Walkthrough', type: :system do
  let!(:organization) { create(:organization, :with_admin) }
  let!(:service_specification) { create(:service_specification, organization: organization) }
  let!(:civil_servant) { create(:civil_servant, :full) }
  let!(:service) do
    create(:service, :current, service_specification: service_specification, civil_servant: civil_servant)
  end

  let!(:organization_administrator) do
    create(:organization_member,
           first_name: 'Johnny',
           last_name: 'Depp',
           organization: organization)
  end

  before do
    sign_in organization_administrator.user
    visit organizations_path

    ExpenseSheetGenerator.new(service).create_expense_sheets!.each(&:editable!)
  end

  around do |spec|
    travel_to Date.parse('2020-09-10') do
      spec.run
    end
  end

  it 'shows the correct nav items', :without_bullet do
    expect(page).to have_ civil_servant.full_name
  end
end
