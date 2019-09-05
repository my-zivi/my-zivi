# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdfs::ExpenseSheet::GeneratorService, type: :service do
  describe '#render' do
    context 'when locale is german' do
      before { I18n.locale = :de }

      after { I18n.locale = I18n.default_locale }

      let(:pdf) { described_class.new(expense_sheet).render }
      let(:expense_sheet) { create :expense_sheet, expense_sheet_data }
      let(:service) { create :service, service_data }
      let(:service_specification) { create :service_specification, identification_number: 82_846 }
      let(:expense_sheet_data) { expense_sheet_data_defaults }
      let(:expense_sheet_data_defaults) do
        {
          beginning: Date.parse('2018-01-01'),
          ending: Date.parse('2018-01-27'),
          extraordinary_expenses: 0,
          extraordinary_expenses_comment: nil,
          user: service.user
        }
      end
      let(:service_data) do
        {
          beginning: Date.parse('2018-01-01'),
          ending: Date.parse('2018-02-23'),
          service_specification: service_specification
        }
      end

      let(:pdf_text_inspector) { PDF::Inspector::Text.analyze(pdf) }
      let(:pdf_page_inspector) { PDF::Inspector::Page.analyze(pdf) }

      let(:expected_texts) do
        [
          'Spesenrapport des Einsatzbetriebes 423 - SWO, Bahnstrasse 18b, 8603 Schwerzenbach',
          'Pflichtenheft:', '82846 MyServiceSpecification',
          'Nachname, Vorname:', 'Zivi Mustermann',
          'Adresse:', 'Bahnstrasse 18b',
          'ZDP-Nr.:', '8603',
          'Gesamteinsatz:', '01.01.2018 bis 23.02.2018 (54 Tage)',
          'Meldeperiode:', '01.01.2018 bis 27.01.2018 (27 Tage)',
          'Taschengeld', '(Fr.)', 'Unterkunft', '(Fr.)',
          'Morgen', '(Fr.)', 'Mittag', '(Fr.)', 'Abend', '(Fr.)', 'Total', '(Fr.)',
          '1', 'Erster Arbeitstag', '5.00', '0.00', '0.00', '9.00', '7.00', '21.00',
          '25', 'Arbeitstage', '5.00', '0.00', '4.00', '9.00', '7.00', '625.00',
          '0', 'Letzter Arbeitstag', '5.00', '0.00', '4.00', '9.00', '0.00', '0.00',
          '2', 'Arbeitsfreie Tage', '5.00', '0.00', '4.00', '9.00', '7.00', '50.00',
          '0', 'Krankheitstage', '5.00', '0.00', '4.00', '9.00', '7.00', '0.00',
          '0', 'Ferientage', '5.00', '0.00', '4.00', '9.00', '7.00', '0.00',
          '0', 'Urlaubstage', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00',
          'inkl. MyString',
          '+', 'Fahrspesen', 'MyString', '20.00',
          '+', 'Arbeitskleider', 'CHF 2.30/Tag für 27 anrechenbare Tage', '32.00',
          'Gesamt:', '748.00',
          'Bankverbindung:', 'CH93 0076 2011 6238 5295 7',
          'Konto-Nr.::', '4470 (200)'
        ]
      end

      it 'renders one page' do
        expect(pdf_page_inspector.pages.size).to eq 1
      end

      it 'renders correct texts' do
        expect(pdf_text_inspector.strings).to eq expected_texts
      end

      context 'when work_clothing_expenses is more than threshold' do
        let(:service_specification) do
          create(
            :service_specification, identification_number: 82_846, work_clothing_expenses: 1000
          )
        end

        let(:expected_texts) do
          [
            'CHF 10.00/Tag für 27 anrechenbare Tage', '32.00'
          ]
        end

        it 'renders correct text' do
          expect(pdf_text_inspector.strings[-8..-7]).to eq expected_texts
        end
      end

      context 'when driving_expenses_comment is empty' do
        let(:expense_sheet_data) do
          expense_sheet_data_defaults.merge(
            driving_expenses_comment: nil,
            user: service.user
          )
        end

        it 'renders correct text' do
          expect(pdf_text_inspector.strings[-12]).to eq 'Keine Angaben'
        end
      end

      context 'when extraordinary_expenses is not empty' do
        let(:expense_sheet_data) do
          expense_sheet_data_defaults.merge(
            extraordinary_expenses: 15_000,
            extraordinary_expenses_comment: 'MyString',
            user: service.user
          )
        end
        let(:expected_texts) do
          %w[+ Ausserordentliche\ Spesen MyString 150.00]
        end

        it 'renders correct text' do
          expect(pdf_text_inspector.strings[-10..-7]).to eq expected_texts
        end
      end
    end
  end
end
