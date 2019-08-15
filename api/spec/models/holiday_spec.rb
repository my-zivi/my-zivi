# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Holiday, type: :model do
  it { is_expected.to validate_presence_of :beginning }
  it { is_expected.to validate_presence_of :ending }
  it { is_expected.to validate_presence_of :holiday_type }
  it { is_expected.to validate_presence_of :description }

  it_behaves_like 'validates that the ending is after beginning' do
    let(:model) { build(:holiday, beginning: beginning, ending: ending) }
  end

  describe '#range' do
    subject(:holiday) { build(:holiday, beginning: beginning, ending: ending) }

    let(:beginning) { Date.parse('2019-04-10') }
    let(:ending) { Date.parse('2019-04-20') }

    it 'returns range of beginning and ending' do
      expect(holiday.range).to eq beginning..ending
    end
  end

  describe '#work_days' do
    context 'when holiday is a company holiday' do
      let(:holiday) { build(:holiday, beginning: Date.parse('2019-04-10'), ending: Date.parse('2019-04-20')) }

      context 'with two public holidays' do
        let(:public_holidays) do
          [
            create(:holiday, :public_holiday, beginning: holiday.beginning, ending: holiday.beginning),
            create(:holiday, :public_holiday, beginning: holiday.beginning + 3, ending: holiday.beginning + 5)
          ]
        end

        let(:expected_work_days) do
          %w[
            2019-04-11
            2019-04-12
            2019-04-16
            2019-04-17
            2019-04-18
            2019-04-19
          ].map { |date| Date.parse date }
        end

        it 'returns only work days without public holidays' do
          expect(holiday.work_days(public_holidays)).to eq expected_work_days
        end
      end

      context 'with no public holidays' do
        let(:expected_work_days) do
          %w[
            2019-04-10
            2019-04-11
            2019-04-12
            2019-04-15
            2019-04-16
            2019-04-17
            2019-04-18
            2019-04-19
          ].map { |date| Date.parse date }
        end

        it { expect(holiday.work_days([])).to eq expected_work_days }
      end
    end

    context 'when holiday is a public holiday' do
      let(:holiday) do
        create(:holiday, :public_holiday, beginning: Date.parse('2019-04-10'), ending: Date.parse('2019-04-20'))
      end

      let(:expected_work_days) do
        [
          Date.parse('2019-04-10'),
          Date.parse('2019-04-11'),
          Date.parse('2019-04-12'),
          Date.parse('2019-04-15'),
          Date.parse('2019-04-16'),
          Date.parse('2019-04-17'),
          Date.parse('2019-04-18'),
          Date.parse('2019-04-19')
        ]
      end

      it { expect(holiday.work_days).to eq expected_work_days }
    end
  end
end
