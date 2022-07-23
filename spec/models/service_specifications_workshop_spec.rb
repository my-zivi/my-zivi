# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceSpecificationsWorkshop, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    it 'defines relations' do
      expect(model).to belong_to(:workshop)
      expect(model).to belong_to(:service_specification)
    end
  end

  describe 'validations' do
    context 'when the model already exists' do
      subject(:model) { described_class.first }

      let(:workshop) { create :workshop }
      let(:service_specification) { create :service_specification }

      before { described_class.create!(workshop: workshop, service_specification: service_specification) }

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
