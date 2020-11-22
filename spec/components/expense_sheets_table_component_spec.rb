# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetsTableComponent, type: :component do
  subject(:rendered) { render_inline(component) }

  let(:component) { described_class.new(expense_sheets: [expense_sheet]) }
  let(:civil_servant) { create(:civil_servant, :full, :with_service, first_name: 'Elsbeth', last_name: 'Wayne') }
  let(:expense_sheet) do
    build(:expense_sheet,
          service: civil_servant.services.first,
          state: :editable,
          id: 1,
          amount: 62,
          beginning: '2020-01-06',
          ending: '2020-01-31')
  end

  let(:rendered_column) { rendered.css('td').map(&:text).reject(&:empty?) }
  let(:rendered_header) { rendered.css('th').map(&:text).reject(&:empty?) }
  let(:can_edit) { true }

  before do
    allow(component).to receive(:can?).with(:edit, expense_sheet).and_return can_edit
  end

  it 'renders a table of expense sheets' do
    expect(rendered.to_s).to include(*described_class::COLUMNS.values.pluck(:label))
    expect(rendered.css('tr').length).to eq 2
    expect(rendered_column).to(
      contain_exactly(
        'Elsbeth Wayne', '06.01.2020', '31.01.2020',
        '26', 'CHF 62.00', I18n.t('activerecord.enums.expense_sheet.states.editable')
      )
    )
  end

  context 'when the user cannot edit expense sheets' do
    let(:can_edit) { false }

    it 'does not render the edit icon' do
      expect(rendered.to_s).not_to include 'fas fa-pen'
    end
  end

  context 'when specifying custom columns' do
    let(:columns) { described_class::COLUMNS.slice(:amount) }
    let(:component) { described_class.new(expense_sheets: [expense_sheet], columns: columns) }

    it 'only renders the specified columns' do
      expect(rendered_column).to contain_exactly('CHF 62.00')
      expect(rendered_header).to contain_exactly(described_class::COLUMNS[:amount][:label])
    end
  end
end
