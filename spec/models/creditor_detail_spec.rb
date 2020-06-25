# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreditorDetail, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations correctly' do
      expect(model).to have_one(:organization)
    end
  end

  describe 'validations' do
    it_behaves_like 'validates presence of required fields', %i[iban bic]
  end
end
