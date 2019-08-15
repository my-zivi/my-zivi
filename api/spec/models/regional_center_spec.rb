# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalCenter, type: :model do
  describe 'validations' do
    subject(:model) { described_class.new }

    it { is_expected.to validate_length_of(:short_name).is_equal_to(2) }

    it_behaves_like 'validates presence of required fields', %i[name address short_name]
  end
end
