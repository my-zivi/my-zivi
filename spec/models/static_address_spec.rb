# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticAddress, type: :model do
  it { expect(described_class.new).to be_readonly }
end
