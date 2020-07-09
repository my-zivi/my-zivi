# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations correctly' do
      expect(model).to belong_to(:address).class_name('Address')
      expect(model).to belong_to(:letter_address).class_name('Address').optional(true)
      expect(model).to belong_to(:creditor_detail)
      expect(model).to have_many(:organization_members)
    end
  end

  describe 'validations' do
    it_behaves_like 'validates presence of required fields', %i[name]
  end
end
