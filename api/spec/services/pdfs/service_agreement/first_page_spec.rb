# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdfs::ServiceAgreement::FirstPage, type: :service do
  describe '#render' do
    context 'when locale is german' do
      before { I18n.locale = :de }

      after { I18n.locale = I18n.default_locale }

      let(:pdf) { described_class.new(service).render }
      let(:service) { create :service }

      let(:pdf_text_inspector) { PDF::Inspector::Text.analyze(pdf) }
      let(:pdf_page_inspector) { PDF::Inspector::Page.analyze(pdf) }

      let(:expected_texts) do
        [
          sender_name, sender_address, sender_zip_city,
          sender_name, sender_address, sender_zip_city,
          'Lieber Zivi',
          'Bitte sende die unterzeichnete Einsatzvereinbarung an obige Adresse. Wenn du ein Fenstercouvert mit Fenster',
          'links oder rechts verwendest, kannst du dieses Deckblatt falten ' \
           'und in das Couvert stecken. Die Adresse ist richtig',
          'platziert. Die Adresse unten rechts wird von uns benutzt um die Einsatzvereinbarung an die Regionalstelle',
          'weiterzuleiten. Ganz am Ende findest du ein Informationsblatt, ' \
          'das dir Auskunft über den Ablauf deines Einsatzes',
          'gibt. Gib bitte den Talon darin am ersten Einsatztag unterschrieben dem Einsatzleiter ab.'
        ].push(*service.civil_servant.regional_center.address.split(', '))
      end
      let(:sender_name) { 'SWO Stiftung Wirtschaft und Öl' }
      let(:sender_address) { 'Hauptstrasse 23d' }
      let(:sender_zip_city) { '9542 Schwerzenbach' }

      let(:envs) do
        {
          SERVICE_AGREEMENT_LETTER_SENDER_NAME: sender_name,
          SERVICE_AGREEMENT_LETTER_SENDER_ADDRESS: sender_address,
          SERVICE_AGREEMENT_LETTER_SENDER_ZIP_CITY: sender_zip_city
        }
      end

      it 'renders one page' do
        expect(pdf_page_inspector.pages.size).to eq 1
      end

      it 'renders correct texts' do
        ClimateControl.modify envs do
          expect(pdf_text_inspector.strings).to eq expected_texts
        end
      end
    end
  end
end
