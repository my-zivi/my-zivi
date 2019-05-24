# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseSheet, type: :model do
  it { is_expected.to validate_presence_of :beginning }
  it { is_expected.to validate_presence_of :ending }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :work_days }
  it { is_expected.to validate_presence_of :bank_account_number }
  it { is_expected.to validate_presence_of :state }

  it { is_expected.to validate_numericality_of(:work_days).only_integer }
  it { is_expected.to validate_numericality_of(:workfree_days).only_integer }
  it { is_expected.to validate_numericality_of(:sick_days).only_integer }
  it { is_expected.to validate_numericality_of(:paid_vacation_days).only_integer }
  it { is_expected.to validate_numericality_of(:unpaid_vacation_days).only_integer }
  it { is_expected.to validate_numericality_of(:driving_expenses).only_integer }
  it { is_expected.to validate_numericality_of(:extraordinary_expenses).only_integer }
  it { is_expected.to validate_numericality_of(:clothing_expenses).only_integer }
  it { is_expected.to validate_numericality_of(:unpaid_company_holiday_days).only_integer }
  it { is_expected.to validate_numericality_of(:paid_company_holiday_days).only_integer }

  it_behaves_like 'validates that the ending is after beginning' do
    let(:model) { build(:expense_sheet, beginning: beginning, ending: ending) }
  end
end
