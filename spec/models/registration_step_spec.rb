# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationStep, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
  end

  context 'with customized steps' do
    before { stub_const('RegistrationStep::ALL', %i[first second third]) }

    describe '#next' do
      it 'returns the correct next step' do
        expect(described_class.new(identifier: :first).next.identifier).to eq :second
        expect(described_class.new(identifier: :second).next.identifier).to eq :third
        expect(described_class.new(identifier: :third).next).to be_nil
      end
    end

    describe '#previous' do
      it 'returns the correct previous step' do
        expect(described_class.new(identifier: :third).previous.identifier).to eq :second
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

    describe 'comparison' do
      let(:other) { described_class.new(identifier: :second) }

      it 'compares self correctly to the given counterpart' do
        expect(described_class.new(identifier: :first) <=> other).to be_negative
        expect(described_class.new(identifier: :second) <=> other).to be_zero
        expect(described_class.new(identifier: :third) <=> other).to be_positive
      end

      context 'when other is nil' do
        subject { described_class.new(identifier: :first) <=> other }

        let(:other) { nil }

        it { is_expected.to be_nil }
      end
    end
  end

  describe 'generated convenience methods' do
    let(:step) { described_class.new(identifier: :address) }

    it 'generates convenience check methods' do
      expect(step.personal_step_completed?).to eq true
      expect(step.address_step_completed?).to eq true
      expect(step.bank_and_insurance_step_completed?).to eq false
      expect(step.service_specific_step_completed?).to eq false
    end
  end
end
