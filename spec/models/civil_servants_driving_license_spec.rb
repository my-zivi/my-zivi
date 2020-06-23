# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServantsDrivingLicense, type: :model do
  subject(:model) { described_class.new }

  it 'has correct relationships' do
    expect(model).to belong_to :driving_license
    expect(model).to belong_to :civil_servant
  end
end
