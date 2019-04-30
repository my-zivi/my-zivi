# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalCenter, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_presence_of :short_name }
  it { is_expected.to validate_length_of(:short_name).is_equal_to(2) }
end
