# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalCenter, type: :model do
  subject(:model) { described_class.new }

  describe 'validations' do
    it_behaves_like 'validates presence of required fields', %i[name address]
  end
end
