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
    subject(:model) { described_class.new }

    it_behaves_like 'validates presence of required fields', %i[iban bic]

    describe 'bic format' do
      it 'validates format correctly' do
        %w[UBSWCHZH19B UBSWCHZH10A CLNACHBL08X RBABCH22814 RAIFCH22651].each do |valid_bic|
          expect(build(:creditor_detail, bic: valid_bic)).to be_valid
        end

        %w[UBSWCHZH1 1111119B150 ABCDEFGIJK UBSWCHZH12].each do |invalid_bic|
          expect(build(:creditor_detail, bic: invalid_bic)).not_to be_valid
        end
      end
    end
  end
end
