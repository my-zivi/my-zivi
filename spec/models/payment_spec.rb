# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  specify(:aggregate_failures) do
    expect(subject).to belong_to(:organization)
    expect(subject).to have_many(:expense_sheets).dependent(:restrict_with_exception)
  end
end
