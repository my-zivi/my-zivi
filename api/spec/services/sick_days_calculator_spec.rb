# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SickDaysCalculator, type: :service do
  describe '.calculate_eligible_sick_days' do
    subject { described_class.calculate_eligible_sick_days(service_days) }

    context 'with exact sick_days_period' do
      let(:service_days) { 30 }

      it { is_expected.to eq 6 }
    end

    context 'with less than 30 service_days' do
      let(:service_days) { 17 }

      it { is_expected.to eq 4 }
    end

    context 'with more than 30 service days and remainder' do
      let(:service_days) { 47 }

      it { is_expected.to eq 10 }
    end
  end
end
