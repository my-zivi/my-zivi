# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServants::RegistrationsHelper, type: :helper do
  describe '#step_icon' do
    it 'returns the correct step icon' do
      identifier, icon = described_class::STEP_ICONS.first
      expect(helper.step_icon(identifier)).to match(/<i class="fas #{icon}/)
    end
  end

  describe '#step_link' do
    subject { helper.step_link(step_identifier, RegistrationStep.new(identifier: :second)) {} }

    before { stub_const('RegistrationStep::ALL', %i[first second third]) }

    context 'when step identifier is behind current step' do
      let(:step_identifier) { :first }

      it { is_expected.to match(/nav-link font-weight-semi-bold done/) }
    end

    context 'when step identifier is equal to the current step' do
      let(:step_identifier) { :second }

      it { is_expected.to match(/nav-link font-weight-semi-bold active/) }
    end

    context 'when step identifier is after current step' do
      let(:step_identifier) { :third }

      it { is_expected.to match(/nav-link font-weight-semi-bold"/) }
    end
  end
end
