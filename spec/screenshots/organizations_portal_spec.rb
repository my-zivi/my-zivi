# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations Portal Screenshots', type: :system, js: true do
  let(:organization) { create(:organization) }
  let(:organization_administrator) do
    create(:organization_member, first_name: 'Therese', last_name: 'Mayer', organization: organization)
  end

  before do
    service_specification = create(:service_specification, organization: organization_administrator.organization)
    create(:service, :civil_servant_agreement_pending, service_specification: service_specification)

    sign_in organization_administrator.user
  end

  it 'renders front page correctly' do
    visit organizations_path
    page.percy_snapshot(page, { name: 'Organizations Dashboard' })
  end

  context 'when organization subscribed to admin' do
    let(:organization) { create(:organization, :with_admin) }

    it 'renders front page correctly' do
      visit organizations_path
      page.percy_snapshot(page, { name: 'Organizations Dashboard with Admin Subscription' })
    end
  end

  context 'when organization subscribed to recruiting' do
    let(:organization) { create(:organization, :with_recruiting) }

    it 'renders front page correctly' do
      visit organizations_path
      page.percy_snapshot(page, { name: 'Organizations Dashboard with Recruiting Subscription' })
    end
  end

  context 'when organization subscribed to recruiting and admin' do
    let(:organization) do
      create(:organization, subscriptions: [build(:recruiting_subscription), build(:admin_subscription)])
    end

    it 'renders front page correctly' do
      visit organizations_path
      page.percy_snapshot(page, { name: 'Organizations Dashboard with Recruiting and Admin Subscription' })
    end
  end
end
