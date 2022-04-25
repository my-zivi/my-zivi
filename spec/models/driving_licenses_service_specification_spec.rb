# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DrivingLicensesServiceSpecification, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations' do
      expect(model).to belong_to(:driving_license)
      expect(model).to belong_to(:service_specification)
    end
  end

  describe 'validations' do
    context 'when the model already exists' do
      subject(:model) { described_class.first }

      let(:driving_license) { create :driving_license }
      let(:service_specification) { create :service_specification }

      before do
        described_class.create!(driving_license: driving_license, service_specification: service_specification)
      end

      it { expect(model).to validate_presence_of(:mandatory) }
    end
  end

  describe 'initialisation' do
    subject(:model) { described_class.new }

    it 'sets mandatory by default to true' do
      expect(model.mandatory).to be true
    end
  end
end
