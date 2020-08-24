# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalCenter, type: :model do
  subject(:model) { described_class.new }

  describe 'validations' do
    it_behaves_like 'validates presence of required fields', %i[name address short_name]
  end

  it 'defines model correctly' do
    expect(model).to have_many(:civil_servants).dependent(:restrict_with_error)
    expect(model).to belong_to(:address)
  end
end
