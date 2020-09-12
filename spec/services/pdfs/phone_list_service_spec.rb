# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdfs::PhoneListService, type: :service do
  describe '#render' do
    context 'when locale is german' do
      around { |spec| I18n.with_locale(:'de-CH') { spec.run } }

      let(:pdf) do
        described_class.new(phone_list_service_specifications, phone_list_beginning, phone_list_ending).render
      end
      let(:civil_servant) { create :civil_servant, :full }
      let(:service) { create(:service, service_data) }
      let(:phone_list_service_specifications) do
        {
          service.service_specification.name => [
            service
          ]
        }
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
        expected_headers +
          [
            service.service_specification.name,
            I18n.t('activerecord.attributes.civil_servant.address'),
            I18n.t('activerecord.attributes.civil_servant.phone'),
            I18n.t('activerecord.attributes.user.email'),
            civil_servant.address.full_compose(', '),
            civil_servant.phone,
            civil_servant.user.email
          ]
      end

      context 'when there is filter dates' do
        let(:phone_list_beginning) { Date.parse('2017-01-01') }
        let(:phone_list_ending) { Date.parse('2018-12-31') }

        let(:expected_headers) do
          [
            I18n.t('pdfs.phone_list.header', date: I18n.l(Time.zone.today)),
            I18n.t('pdfs.phone_list.title.with_date',
                   beginning: I18n.l(phone_list_beginning), ending: I18n.l(phone_list_ending))
          ]
        end

        it 'renders the page correctly', aggregate_failures: true do
          expect(pdf_page_inspector.pages.size).to eq 1
          expect(pdf_text_inspector.strings.join(' ')).to eq expected_texts.join(' ')
        end
      end

      context 'when there is no filter dates' do
        let(:phone_list_beginning) { nil }
        let(:phone_list_ending) { nil }

        let(:expected_headers) do
          [
            I18n.t('pdfs.phone_list.header', date: I18n.l(Time.zone.today)),
            I18n.t('pdfs.phone_list.title.without_date')
          ]
        end

        it 'renders the page correctly', aggregate_failures: true do
          expect(pdf_page_inspector.pages.size).to eq 1
          expect(pdf_text_inspector.strings.join(' ')).to eq expected_texts.join(' ')
        end
      end
    end
  end
end
