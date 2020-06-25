# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_many(:expense_sheets).dependent(:restrict_with_exception) }
end
