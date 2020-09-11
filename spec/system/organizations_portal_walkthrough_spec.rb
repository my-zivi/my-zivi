# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations Portal Walkthrough', type: :system do
  let!(:organization) { create(:organization) }
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

    ExpenseSheetGenerator.new(service).create_expense_sheets.each(&:editable!)
  end

  around do |spec|
    travel_to Date.parse('2020-09-10') do
      spec.run
    end
  end

  # rubocop:disable RSpec/ExampleLength
  it 'can navigate through portal', :without_bullet do
    expect(page).to have_content I18n.t('organizations.overview.index.welcome_back.title', name: 'Johnny Depp')

    click_on I18n.t('base.organizations.navbar.civil_servants')
    expect(page).to have_content I18n.t('organizations.civil_servants.index.title')
    expect(page).to have_content civil_servant.full_name

    click_on I18n.t('base.organizations.navbar.service_specifications')
    expect(page).to have_content I18n.t('organizations.service_specifications.index.title')
    expect(page).to have_content service_specification.name

    click_on I18n.t('base.organizations.navbar.expense_sheets')
    expect(page).to have_content I18n.t('organizations.expense_sheets.index.title')
    expect(page).to have_content(civil_servant.full_name).twice

    click_on I18n.t('base.organizations.navbar.payments')
    expect(page).to have_content I18n.t('organizations.payments.index.title')

    click_on I18n.t('base.organizations.navbar.organization_members')
    expect(page).to have_content I18n.t('organizations.organization_members.index.title')
    expect(page).to have_content organization_administrator.full_name

    click_on I18n.t('base.organizations.navbar.phone_list')
    expect(page).to have_content I18n.t('organizations.phone_list.index.title.without_filter')

    click_on I18n.t('base.organizations.navbar.profile')
    expect(page).to have_content organization_administrator.full_name
  end
  # rubocop:enable RSpec/ExampleLength
end
