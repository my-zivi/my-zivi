# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WhitelistedJwt, type: :model do
  it { is_expected.to belong_to :civil_servant }
end
