# frozen_string_literal: true

RSpec.shared_examples_for 'adds one day to linear duration' do |range|
  it 'returns correct ending date', :aggregate_failures do
    range.each do |delta|
      ending = ShortServiceCalculator.new(beginning).calculate_ending_date(delta)
      expect(ending).to eq(beginning + delta)
    end
  end
end
