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
      let(:user) { create :user }
      let(:phone_list_dates) do
        OpenStruct.new(
          beginning: Date.parse('2017-01-01'),
          ending: Date.parse('2018-12-31')
        )
      end
      let(:phone_list_service_specifications) do
        [Service.includes(:service_specification, :user).first]
          .group_by { |service| service.service_specification.name }
      end
      let(:service_data) do
        {
          beginning: Date.parse('2018-01-01'),
          ending: Date.parse('2018-02-23'),
          user: user
        }
      end

      let(:pdf_text_inspector) { PDF::Inspector::Text.analyze(pdf) }
      let(:pdf_page_inspector) { PDF::Inspector::Page.analyze(pdf) }

      let(:expected_texts) do
        [
          I18n.t('pdfs.phone_list.header', date: I18n.l(Time.zone.today)),
          'Telefonliste vom 01.01.2017 bis 31.12.2018',
          'MyServiceSpecification',
          'Nachname', 'Vorname', 'Adresse', 'PLZ / Ort', 'Telefonnummer', 'Email',
          'Zivi', 'Mustermann', 'Bahnstrasse 18b', '8603 Schwerzenbach', '+41 (0) 76 123 45', '67', user.email
        ]
      end

      it 'renders one page' do
        expect(pdf_page_inspector.pages.size).to eq 1
      end

      it 'renders correct texts' do
        expect(pdf_text_inspector.strings).to eq expected_texts
      end
    end
  end
end
