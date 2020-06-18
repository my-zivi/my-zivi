# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServantsWorkshop, type: :model do
  subject(:model) { described_class.new }

  it 'has correct relationships', :aggregate_failures do
    expect(model).to belong_to :civil_servant
    expect(model).to belong_to :workshop
  end
end
