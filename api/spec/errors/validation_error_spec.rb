# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ValidationError do
  describe '#to_h' do
    subject(:validation_error_hash) { described_class.new(errors, full_messages).to_h }

    let(:errors) { { first_name: 'is blank' } }
    let(:full_messages) { ['First name is blank'] }

    it 'serializes the error to a hash' do
      expect(validation_error_hash).to eq(
        errors: { first_name: 'is blank' },
        human_readable_descriptions: ['First name is blank']
      )
    end

    context 'with ActiveModel::Errors' do
      let(:errors) { build(:civil_servant, first_name: nil).tap(&:validate).errors }
      let(:full_messages) { errors.full_messages }

      it 'serializes the error to a hash' do
        expect(validation_error_hash).to eq(
          errors: { first_name: [I18n.t('errors.messages.blank')] },
          human_readable_descriptions: full_messages
        )
      end
    end
  end

  describe '#merge!' do
    let(:validation_error) { described_class.new(first_errors, first_full_messages) }
    let(:first_errors) { { first_name: ['is blank'] } }
    let(:first_full_messages) { ['First name is blank'] }
    let(:second_errors) { { last_name: ['is blank'] } }
    let(:second_full_messages) { ['Last name is blank'] }

    before { validation_error.merge!(described_class.new(second_errors, second_full_messages)) }

    it 'mutably merges the given error into the first error', :aggregate_failures do
      expect(validation_error.validation_errors).to eq(first_name: ['is blank'], last_name: ['is blank'])
      expect(validation_error.human_readable_descriptions).to eq(['First name is blank', 'Last name is blank'])
    end
  end

  describe '#empty?' do
    subject { described_class.new(errors, full_messages).empty? }

    context 'when there are errors' do
      let(:errors) { { first_name: 'is blank' } }
      let(:full_messages) { ['First name is blank'] }

      it { is_expected.to eq false }
    end

    context 'when there are no errors' do
      let(:errors) { {} }
      let(:full_messages) { [] }

      it { is_expected.to eq true }
    end

    context 'when there are errors but no description' do
      let(:errors) { { first_name: 'is blank' } }
      let(:full_messages) { [] }

      it { is_expected.to eq false }
    end
  end
end
