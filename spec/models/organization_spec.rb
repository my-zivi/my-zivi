# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { is_expected.to validate_presence_of :name }

  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations correctly' do
      expect(model).to belong_to(:address).class_name('Address')
      expect(model).to belong_to(:letter_address).class_name('Address').optional(true)
    end
  end
end
