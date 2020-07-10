# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdfs::PhoneListService, type: :service do
  describe '#render' do
    context 'when locale is german' do
      before do
        I18n.locale = :de
        create(:service, service_data)
      end

      after { I18n.locale = I18n.default_locale }

      let(:pdf) { described_class.new(phone_list_service_specifications, phone_list_dates).render }
      let(:civil_servant) { create :civil_servant, :full }
      let(:phone_list_dates) do
        OpenStruct.new(
          beginning: Date.parse('2017-01-01'),
          ending: Date.parse('2018-12-31')
        )
      end
      let(:phone_list_service_specifications) do
        [Service.includes(:service_specification, :civil_servant).first]
          .group_by { |service| service.service_specification.name }
      end
      let(:service_data) do
        {
          beginning: Date.parse('2018-01-01'),
          ending: Date.parse('2018-02-23'),
          civil_servant: civil_servant
        }
      end

      let(:pdf_text_inspector) { PDF::Inspector::Text.analyze(pdf) }
      let(:pdf_page_inspector) { PDF::Inspector::Page.analyze(pdf) }

      let(:expected_texts) do
        [
          I18n.t('pdfs.phone_list.header', date: I18n.l(Time.zone.today)),
          'Telefonliste vom 01.01.2017 bis 31.12.2018',
          'MyServiceSpecification',
          'Vorname', 'Nachname', 'Strasse', 'PLZ / Ort', 'Telefonnummer', 'E-Mail',
          civil_servant.first_name, civil_servant.last_name,
          civil_servant.address.street, civil_servant.address.zip_with_city,
          civil_servant.phone, civil_servant.user.email
        ]
      end

      it 'renders the page correctly', aggregate_failures: true do
        expect(pdf_page_inspector.pages.size).to eq 1
        expect(pdf_text_inspector.strings.join(' ')).to eq expected_texts.join(' ')
      end
    end
  end
end
