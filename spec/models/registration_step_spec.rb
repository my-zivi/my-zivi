# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationStep, type: :model do
  before { stub_const('RegistrationStep::ALL', %i[first second third]) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
  end

  describe '#next' do
    it 'returns the correct next step' do
      expect(described_class.new(identifier: :first).next.identifier).to eq :second
      expect(described_class.new(identifier: :second).next.identifier).to eq :third
      expect(described_class.new(identifier: :third).next).to be_nil
    end
  end

  describe '#previous' do
    it 'returns the correct previous step' do
      expect(described_class.new(identifier: :thid).previous.identifier).to eq :second
      expect(described_class.new(identifier: :second).previous.identifier).to eq :first
      expect(described_class.new(identifier: :first).previous).to be_nil
    end
  end

  describe '#nth' do
    it 'returns the correct step at nth index, relative to the current index' do
      expect(described_class.new(identifier: :first).nth(2).identifier).to eq :third
    end
  end

  describe '#last?' do
    it 'checks if last step was reached' do
      expect(described_class.new(identifier: :third)).to be_last
      expect(described_class.new(identifier: :second)).not_to be_last
    end
  end
end
