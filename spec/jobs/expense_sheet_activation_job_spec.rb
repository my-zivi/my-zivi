# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetActivationJob, type: :job do
  let(:service) do
    create(:service,
           beginning: '2020-01-06',
           ending: '2020-03-27')
  end

  let!(:closed_expense_sheet) do
    create(:expense_sheet, :closed,
           beginning: '2020-01-06',
           ending: '2020-01-31',
           service: service)
  end

  let!(:not_yet_editable_expense_sheet) do
    create(:expense_sheet, :locked,
           beginning: '2020-02-01',
           ending: '2020-02-29',
           service: service)
  end

  let!(:locked_expense_sheet) do
    create(:expense_sheet, :locked,
           beginning: '2020-03-01',
           ending: '2020-03-27',
           service: service)
  end

  around do |spec|
    travel_to(Date.parse('2020-02-02')) { spec.run }
  end

  it 'sets the currently due expense sheets to editable but does not touch other expense sheets' do
    expect { described_class.new.perform }.to(
      change { not_yet_editable_expense_sheet.reload.state }.from('locked').to('editable')
    )

    expect(closed_expense_sheet.closed?).to be true
    expect(locked_expense_sheet.locked?).to be true
  end

  context 'when current expense sheet is already editable' do
    before { not_yet_editable_expense_sheet.editable! }

    it 'does not touch the already editable expense sheet' do
      expect { described_class.new.perform }.not_to(change(not_yet_editable_expense_sheet, :reload))
    end
  end
end
