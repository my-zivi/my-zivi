# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Service, type: :model do
  it { is_expected.to validate_presence_of :ending }
  it { is_expected.to validate_presence_of :beginning }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :eligible_personal_vacation_days }
  it { is_expected.to validate_presence_of :feedback_mail_sent }
  it { is_expected.to validate_presence_of :first_swo_service }
  it { is_expected.to validate_presence_of :long_service }
  it { is_expected.to validate_presence_of :probation_service }
  it { is_expected.to validate_presence_of :service_specification }
  it { is_expected.to validate_presence_of :service_type }

  it_behaves_like 'validates that the ending is after beginning' do
    let(:model) { build(:service, beginning: beginning, ending: ending) }
  end

  describe '#duration' do
    let(:service) { build(:service, beginning: beginning, ending: beginning + 26.days) }
    let(:beginning) { Time.zone.today.beginning_of_week }

    it 'returns the duration of the service' do
      expect(service.duration).to eq 26
    end
  end

  describe 'ending_is_friday validation' do
    subject { build(:service, ending: ending).tap(&:validate).errors.added? :ending, :not_a_friday }

    let(:ending) { Time.zone.today.at_end_of_week - 2.days }

    context 'when ending is a friday' do
      it { is_expected.to be false }
    end

    context 'when ending is a saturday' do
      let(:ending) { Time.zone.today.at_end_of_week - 1.day }

      it { is_expected.to be true }
    end
  end

  describe 'beginning_is_monday validation' do
    subject { build(:service, beginning: beginning).tap(&:validate).errors.added? :beginning, :not_a_monday }

    let(:beginning) { Time.zone.today.at_beginning_of_week }

    context 'when beginning is a monday' do
      it { is_expected.to be false }
    end

    context 'when beginning is a tuesday' do
      let(:beginning) { Time.zone.today.at_beginning_of_week + 1.day }

      it { is_expected.to be true }
    end
  end
end