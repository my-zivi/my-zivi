# frozen_string_literal: true

RSpec.shared_examples_for 'adds one day to linear duration' do |range|
  it 'returns correct ending date', :aggregate_failures do
    range.each do |delta|
      ending = ServiceCalculator.new(beginning).calculate_ending_date(delta)
      expect((ending - beginning).to_i).to eq(delta)
    end
  end
end
