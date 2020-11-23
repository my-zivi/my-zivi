# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::PaymentsHelper do
  describe '#payment_badge' do
    subject { helper.payment_badge(payment) }

    context 'when payment is open' do
      let(:payment) { build_stubbed(:payment) }

      it { is_expected.to include I18n.t('organizations.payments.badges.open.title') }
    end

    context 'when payment is paid' do
      let(:payment) { build_stubbed(:payment, :paid) }

      it { is_expected.to include I18n.t('organizations.payments.badges.paid.title') }
    end
  end

  describe '#expense_sheet_collection_value' do
    subject(:label) { helper.expense_sheet_collection_value(expense_sheet) }

    let(:civil_servant) { build(:civil_servant, first_name: 'Lord', last_name: 'Voldemort') }
    let(:expense_sheet) do
      build(:expense_sheet,
            civil_servant: civil_servant,
            amount: 5_020,
            beginning: Date.parse('2020-01-01'),
            ending: Date.parse('2020-01-31'))
    end

    it 'returns a collection label' do
      expect(label).to include 'Lord Voldemort', '01.01.2020', '31.01.2020', 'CHF 5\'020.00'
    end

    context 'when an evil civil servants tries to XSS' do
      let(:civil_servant) { build(:civil_servant, first_name: '<script>Lord</script>', last_name: '<b>Voldemort</b>') }

      it 'sanitizes the output' do
        expect(label).to include 'Lord Voldemort'
      end
    end
  end
end
