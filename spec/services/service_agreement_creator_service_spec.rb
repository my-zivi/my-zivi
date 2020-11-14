# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceAgreementCreator, type: :service do
  describe '#call' do
    subject(:created_service_agreement) { described_class.new(service_creator).call(service_agreement_params) }

    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let(:old_civil_servant) { create :civil_servant, :full }
    let(:old_civil_servant_service) { create :service, service_specification: service_specification }

    let(:valid_service_agreement_params) do
      attributes_for(:service, :civil_servant_agreement_pending, :unconfirmed, :future)
        .slice(:beginning, :ending, :service_type)
        .merge(service_specification_id: service_specification.id)
    end

    context 'when a organization member creates a service agreement' do
      let(:org_member) { create :organization_member, organization: organization }
      let(:service_creator) { org_member }

      context 'with existing civil servant' do
        let!(:civil_servant) { create(:civil_servant, :full) }
        let(:service_agreement_params) do
          valid_service_agreement_params.merge(
            civil_servant_attributes: {
              user_attributes: {
                email: civil_servant.user.email
              }
            }
          )
        end

        context 'with valid parameters' do
          it 'creates a new service agreement and redirects back to the service specifications list' do
            expect { created_service_agreement }.to change(Service, :count).by(1).and change(CivilServant, :count).by(0)
          end
        end

        context 'with invalid parameters' do
          let(:service_agreement_params) { valid_service_agreement_params.merge(beginning: nil) }

          it 'does not create a new service agreement and renders an error' do
            expect { created_service_agreement }.to change(Service, :count).by(0).and change(CivilServant, :count).by(0)
          end
        end
      end

      context 'with new civil servant -> invite' do
        let(:service_agreement_params) do
          valid_service_agreement_params.merge(
            civil_servant_attributes: {
              first_name: 'Hans',
              last_name: 'Hugentobler',
              user_attributes: {
                email: 'hans@hugentobler.com'
              }
            }
          )
        end

        context 'with valid parameters' do
          it 'creates a new service agreement and redirects back to the service specifications list' do
            expect { created_service_agreement }.to change(Service, :count).by(1).and change(CivilServant, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          let(:service_agreement_params) { valid_service_agreement_params.merge(beginning: nil) }

          it 'does not create a new service agreement and renders an error' do
            expect { created_service_agreement }.to change(Service, :count).by(0).and change(CivilServant, :count).by(0)
          end
        end
      end
    end
  end
end
