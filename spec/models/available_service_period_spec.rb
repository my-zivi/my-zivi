# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AvailableServicePeriod, type: :model do
  subject(:model) { described_class.new }

  it_behaves_like 'validates presence of required fields', %i[beginning ending]
end
