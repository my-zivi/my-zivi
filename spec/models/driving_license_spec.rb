# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DrivingLicense, type: :model do
  subject(:model) { build :driving_license }

  it 'defines model correctly', :aggregate_failures do
    expect(model).to validate_presence_of :name

    expect(model).to have_many(:civil_servants_driving_licenses)
    expect(model).to have_many(:civil_servants).through(:civil_servants_driving_licenses)
    expect(model).to have_many(:driving_licenses_service_specifications)
    expect(model).to have_many(:service_specifications).through(:driving_licenses_service_specifications)
  end
end
