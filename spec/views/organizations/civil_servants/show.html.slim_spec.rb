# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/civil_servants/show.html.erb', type: :view do
  subject { rendered }

  let(:civil_servant) { build(:civil_servant, :full, **civil_servant_attributes) }
  let(:civil_servant_attributes) do
    {
      first_name: 'Zivi',
      last_name: 'Muster',
      zdp: 321_987,
      hometown: 'Entenhausen',
      phone: '079 893 12 34',
      birthday: '2000-04-27',
      iban: 'CH5889144398732554175',
      health_insurance: 'TheC4r3'
    }
  end

  let(:displayed_civil_servant_attributes) do
    civil_servant_attributes.merge(
      birthday: '27.04.2000',
      primary_line: 'Zivi Mustermann',
      street: 'Musterstrasse 99',
      city: 'Beispielhausen',
      zip: '1111',
      regional_center: 'Regionalzentrum Rüti/ZH'
    )
  end

  before do
    assign(:civil_servant, civil_servant)
    render
  end

  it { is_expected.to include(*displayed_civil_servant_attributes.values.map(&:to_s)) }
end
