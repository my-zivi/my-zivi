# frozen_string_literal: true

RSpec.shared_examples_for 'validates presence of required fields' do |fields|
  subject(:model) { described_class.new }

  it 'validates that required fields are present' do
    fields.each do |field|
      expect(model).to validate_presence_of field
    end
  end
end
