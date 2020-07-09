# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Workshop, type: :model do
  it { is_expected.to validate_presence_of :name }

  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'has correct relations' do
      expect(model).to have_many(:service_specifications).through(:service_specifications_workshops)
      expect(model).to have_many(:civil_servants).through(:civil_servants_workshops)
    end
  end
end
