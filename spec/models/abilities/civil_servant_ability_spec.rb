# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Abilities::CivilServantAbility, type: :model do
  subject(:ability) { described_class.new(civil_servant) }

  context 'when civil servant has not completed registration yet' do
    let(:civil_servant) { build(:civil_servant) }

    it 'can only access the registration page and fill out profile' do
      expect(ability).to be_able_to(:access, :registration_page)
      expect(ability).not_to be_able_to(:access, :civil_servant_portal)
      expect(ability).to be_able_to(:manage, civil_servant)
    end
  end

  context 'when civil servant has completed registration' do
    let(:civil_servant) { build(:civil_servant, :service_specific_step_completed) }

    it 'can access the portal but cannot go back to registration step' do
      expect(ability).to be_able_to(:access, :civil_servant_portal)
      expect(ability).not_to be_able_to(:access, :registration_page)
      expect(ability).to be_able_to(:manage, civil_servant)
    end
  end
end
