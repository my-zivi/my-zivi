# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations Portal Dashboard', type: :system do
  let!(:organization) { create(:organization) }
  let!(:organization_administrator) do
    create(:organization_member,
           first_name: 'Johnny',
           last_name: 'Depp',
           organization: organization)
  end

  before do
    sign_in organization_administrator.user
    visit organizations_path
  end

  around do |spec|
    travel_to Date.parse('2020-09-10') do
      spec.run
    end
  end

  describe 'the navigation' do
    let(:expected_nav_items) { %w[base.organizations.navbar.dashboard base.organizations.navbar.sign_out] }

    let(:unexpected_nav_items) do
      %w[
        base.organizations.navbar.civil_servants
        base.organizations.navbar.service_agreements
        base.organizations.navbar.services_overview
        base.organizations.navbar.service_specifications
        base.organizations.navbar.job_postings
        base.organizations.navbar.expense_sheets
        base.organizations.navbar.payments
        base.organizations.navbar.phone_list
        base.organizations.navbar.organization_information
        base.organizations.navbar.organization_members
        base.organizations.navbar.profile
      ]
    end

    it 'shows the expected nav items' do
      expected_nav_items.each do |expected_nav_item|
        expect(page).to have_css('li.nav-item > a', text: I18n.t(expected_nav_item))
      end

      expect(page).to have_css('li.nav-item > a', count: expected_nav_items.size)
    end

    it 'does not show any unexpected nav items' do
      unexpected_nav_items.each do |unexpected_nav_item|
        expect(page).not_to have_css('li.nav-item > a', text: I18n.t(unexpected_nav_item))
      end
    end

    context 'when organization has admin subscription' do
      let(:organization) { create(:organization, :with_admin) }

      let(:expected_nav_items) do
        %w[
          base.organizations.navbar.dashboard
          base.organizations.navbar.civil_servants
          base.organizations.navbar.service_agreements
          base.organizations.navbar.services_overview
          base.organizations.navbar.service_specifications
          base.organizations.navbar.expense_sheets
          base.organizations.navbar.payments
          base.organizations.navbar.phone_list
          base.organizations.navbar.organization_information
          base.organizations.navbar.organization_members
          base.organizations.navbar.profile
          base.organizations.navbar.sign_out
        ]
      end

      let(:unexpected_nav_items) do
        %w[base.organizations.navbar.job_postings]
      end

      it 'shows the expected nav items' do
        expected_nav_items.each do |expected_nav_item|
          expect(page).to have_css('li.nav-item > a', text: I18n.t(expected_nav_item))
        end

        expect(page).to have_css('li.nav-item > a', count: expected_nav_items.size)
      end

      it 'does not show any unexpected nav items' do
        unexpected_nav_items.each do |unexpected_nav_item|
          expect(page).not_to have_css('li.nav-item > a', text: I18n.t(unexpected_nav_item))
        end
      end
    end

    context 'when organization has recruiting subscription' do
      let(:organization) { create(:organization, :with_recruiting) }

      let(:expected_nav_items) do
        %w[
          base.organizations.navbar.dashboard
          base.organizations.navbar.job_postings
          base.organizations.navbar.organization_information
          base.organizations.navbar.organization_members
          base.organizations.navbar.profile
          base.organizations.navbar.sign_out
        ]
      end

      let(:unexpected_nav_items) do
        %w[
          base.organizations.navbar.civil_servants
          base.organizations.navbar.service_agreements
          base.organizations.navbar.services_overview
          base.organizations.navbar.service_specifications
          base.organizations.navbar.expense_sheets
          base.organizations.navbar.payments
          base.organizations.navbar.phone_list
        ]
      end

      it 'shows the expected nav items' do
        expected_nav_items.each do |expected_nav_item|
          expect(page).to have_css('li.nav-item > a', text: I18n.t(expected_nav_item))
        end

        expect(page).to have_css('li.nav-item > a', count: expected_nav_items.size)
      end

      it 'does not show any unexpected nav items' do
        unexpected_nav_items.each do |unexpected_nav_item|
          expect(page).not_to have_css('li.nav-item > a', text: I18n.t(unexpected_nav_item))
        end
      end
    end
  end

  describe 'dashboard content' do
    let(:expected_content_strings) do
      [I18n.t('organizations.overview.index.cards.welcome_back.title', name: organization_administrator.full_name)]
    end

    let(:unexpected_content_strings) do
      [
        I18n.t('organizations.overview.index.cards.active_services.title'),
        I18n.t('organizations.overview.index.cards.editable_expense_sheets.title'),
        I18n.t('organizations.overview.index.cards.job_postings.title'),
        I18n.t('organizations.overview.index.cards.phone_lists.title'),
        I18n.t('organizations.overview.index.cards.services_table.title')
      ]
    end

    it 'renders expected content' do
      expected_content_strings.each do |expected_content_string|
        expect(page).to have_content(expected_content_string)
      end
    end

    it 'does not render unexpected content' do
      unexpected_content_strings.each do |unexpected_content_string|
        expect(page).not_to have_content(unexpected_content_string)
      end
    end

    context 'when organization has admin subscription' do
      let(:organization) { create(:organization, :with_admin) }

      let(:expected_content_strings) do
        [
          I18n.t('organizations.overview.index.cards.welcome_back.title', name: organization_administrator.full_name),
          I18n.t('organizations.overview.index.cards.active_services.title'),
          I18n.t('organizations.overview.index.cards.editable_expense_sheets.title'),
          I18n.t('organizations.overview.index.cards.phone_lists.title'),
          I18n.t('organizations.overview.index.cards.services_table.title')
        ]
      end

      let(:unexpected_content_strings) do
        [I18n.t('organizations.overview.index.cards.job_postings.title')]
      end

      it 'renders expected content' do
        expected_content_strings.each do |expected_content_string|
          expect(page).to have_content(expected_content_string)
        end
      end

      it 'does not render unexpected content' do
        unexpected_content_strings.each do |unexpected_content_string|
          expect(page).not_to have_content(unexpected_content_string)
        end
      end
    end

    context 'when organization has recruiting subscription' do
      let(:organization) { create(:organization, :with_recruiting) }

      let(:expected_content_strings) do
        [
          I18n.t('organizations.overview.index.cards.welcome_back.title', name: organization_administrator.full_name),
          I18n.t('organizations.overview.index.cards.job_postings.title')
        ]
      end

      let(:unexpected_content_strings) do
        [
          I18n.t('organizations.overview.index.cards.active_services.title'),
          I18n.t('organizations.overview.index.cards.editable_expense_sheets.title'),
          I18n.t('organizations.overview.index.cards.phone_lists.title'),
          I18n.t('organizations.overview.index.cards.services_table.title')
        ]
      end

      it 'renders expected content' do
        expected_content_strings.each do |expected_content_string|
          expect(page).to have_content(expected_content_string)
        end
      end

      it 'does not render unexpected content' do
        unexpected_content_strings.each do |unexpected_content_string|
          expect(page).not_to have_content(unexpected_content_string)
        end
      end
    end
  end
end
