# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServantsDrivingLicense do
  subject(:model) { described_class.new }

  it 'has correct relationships', :aggregate_failures do
    expect(model).to belong_to :driving_license
    expect(model).to belong_to :civil_servant
  end
end
