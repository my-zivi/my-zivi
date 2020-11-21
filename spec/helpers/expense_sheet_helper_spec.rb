# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheetHelper do
  describe '#expense_sheet_state_badge' do
    subject(:badge) { helper.expense_sheet_state_badge(expense_sheet_state) }

    shared_examples_for 'contains correct badge' do |badge_class|
      it 'yields the correct badge' do
        name = I18n.t(expense_sheet_state, scope: 'activerecord.enums.expense_sheet.states')
        expect(badge).to match(%r{\A<div.+class="badge #{badge_class}">#{name}</div>\z})
      end
    end

    context 'when it is locked' do
      it_behaves_like 'contains correct badge', 'badge-secondary'
    end

    context 'when it is editable' do
      let(:expense_sheet_state) { 'editable' }

      it_behaves_like 'contains correct badge', 'badge-primary'
    end

    context 'when it is closed' do
      let(:expense_sheet_state) { 'closed' }

      it_behaves_like 'contains correct badge', 'badge-success'
    end

    context 'when it is nil' do
      let(:expense_sheet_state) { nil }

      it { is_expected.to be_nil }
    end
  end
end
