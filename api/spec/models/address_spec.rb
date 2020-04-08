# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  it { is_expected.to validate_numericality_of(:zip).only_integer }

  it_behaves_like 'validates presence of required fields', %i[
    street
    zip
    city
  ]
end
