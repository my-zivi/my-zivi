# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceAgreementCreator, type: :service do
  describe '#call' do
    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let(:old_civil_servant) { create :civil_servant, :full }
    let(:old_civil_servant_service) { create :service, service_specification: service_specification }
    

    context 'when a organization member creates a service agreement' do
      let(:org_member) { create :organization_member, organization: organization }




    end
  end
end
