# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations Portal Dashboard', type: :system do
  let(:organization) { create(:organization) }
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

  describe 'the navigation' do
    let(:expected_nav_items) { %w[dashboard sign_out] }

    let(:unexpected_nav_items) do
      %w[
        civil_servants
        service_agreements
        services_overview
        service_specifications
        job_postings
        expense_sheets
        payments
        phone_list
        organization_information
        organization_members
        profile
      ]
    end

    it 'shows the expected nav items' do
      expected_nav_items.each do |expected_nav_item|
        expected_text = I18n.t(expected_nav_item, scope: %i[base organizations navbar])
        expect(page).to have_css('li.nav-item > a', text: expected_text)
      end

      expect(page).to have_css('li.nav-item > a', count: expected_nav_items.size)
    end

    it 'does not show any unexpected nav items' do
      unexpected_nav_items.each do |unexpected_nav_item|
        unexpected_text = I18n.t(unexpected_nav_item, scope: %i[base organizations navbar])
        expect(page).not_to have_css('li.nav-item > a', text: unexpected_text)
      end
    end

    context 'when organization has admin subscription' do
      let(:organization) { create(:organization, :with_admin) }

      let(:expected_nav_items) do
        %w[
          dashboard
          civil_servants
          service_agreements
          services_overview
          service_specifications
          expense_sheets
          payments
          phone_list
          organization_information
          organization_members
          profile
          sign_out
        ]
      end

      let(:unexpected_nav_items) do
        %w[job_postings]
      end

      it 'shows the expected nav items' do
        expected_nav_items.each do |expected_nav_item|
          expected_text = I18n.t(expected_nav_item, scope: %i[base organizations navbar])
          expect(page).to have_css('li.nav-item > a', text: expected_text)
        end

        expect(page).to have_css('li.nav-item > a', count: expected_nav_items.size)
      end

      it 'does not show any unexpected nav items' do
        unexpected_nav_items.each do |unexpected_nav_item|
          unexpected_text = I18n.t(unexpected_nav_item, scope: %i[base organizations navbar])
          expect(page).not_to have_css('li.nav-item > a', text: unexpected_text)
        end
      end
    end

    context 'when organization has recruiting subscription' do
      let(:organization) { create(:organization, :with_recruiting) }

      let(:expected_nav_items) do
        %w[
          dashboard
          job_postings
          organization_information
          organization_members
          profile
          sign_out
        ]
      end

      let(:unexpected_nav_items) do
        %w[
          civil_servants
          service_agreements
          services_overview
          service_specifications
          expense_sheets
          payments
          phone_list
        ]
      end

      it 'shows the expected nav items' do
        expected_nav_items.each do |expected_nav_item|
          expected_text = I18n.t(expected_nav_item, scope: 'base.organizations.navbar')
          expect(page).to have_css('li.nav-item > a', text: expected_text)
        end

        expect(page).to have_css('li.nav-item > a', count: expected_nav_items.size)
      end

      it 'does not show any unexpected nav items' do
        unexpected_nav_items.each do |unexpected_nav_item|
          unexpected_text = I18n.t(unexpected_nav_item, scope: %i[base organizations navbar])
          expect(page).not_to have_css('li.nav-item > a', text: unexpected_text)
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
