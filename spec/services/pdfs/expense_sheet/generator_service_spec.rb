# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdfs::ExpenseSheet::GeneratorService, type: :service do
  describe '#render' do
    context 'when locale is german' do
      before { I18n.locale = :'de-CH' }

      after { I18n.locale = I18n.default_locale }

      let(:pdf) { described_class.new(expense_sheet).render }
      let(:expense_sheet) { create :expense_sheet, expense_sheet_data }
      let(:service) { create :service, service_data }
      let(:service_specification) { create :service_specification, identification_number: 82_846 }
      let(:expense_sheet_data) do
        {
          beginning: Date.parse('2018-01-01'),
          ending: Date.parse('2018-01-27'),
          extraordinary_expenses: 10,
          extraordinary_expenses_comment: 'Bier',
          driving_expenses_comment: nil,
          service: service
        }
      end
      let(:service_data) do
        {
          beginning: Date.parse('2018-01-01'),
          ending: Date.parse('2018-02-23'),
          service_specification: service_specification
        }
      end
      let(:pdf_page_inspector) { PDF::Inspector::Page.analyze(pdf) }

      it 'renders first page correctly' do
        expect(pdf_page_inspector.pages.size).to eq 1
        expect(pdf).not_to be_nil
      end
    end
  end
end
