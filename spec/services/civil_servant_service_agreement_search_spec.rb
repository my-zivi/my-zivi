# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServantServiceAgreementSearch, type: :service do
  describe '#filtered_all_civil_servants' do
    subject(:search_result) { described_class.filtered_all_civil_servants(search_term) }

    let!(:brigitte) do
      create(:civil_servant, :full, :with_service, first_name: 'Brigitte', last_name: 'Stefenson')
    end
    let!(:peter) do
      create(:civil_servant, :full, :with_service, first_name: 'Peter', last_name: 'Parker')
    end
    let!(:paul) do
      create(:civil_servant, :full, :with_service, first_name: 'Paul', last_name: 'Alien')
    end
    let!(:birgitte) do
      create(:civil_servant, :full, first_name: 'Birgitte', last_name: 'Magdalena')
    end

    context 'when there is no search term' do
      let(:search_term) { '' }

      it 'lists the first 20 of all civil servants' do
        expect(search_result).to contain_exactly(brigitte, peter, paul, birgitte)
      end
    end

    context 'when there is a search term' do
      context 'when the search term is part of the first name' do
        let(:search_term) { 'brig' }

        it 'lists the civil servants matching the search term' do
          expect(search_result).to contain_exactly(brigitte)
        end
      end

      context '' do
      end
    end
  end

  describe '#filtered_organization_civil_servants' do
    subject(:search_result) { described_class.filtered_organization_civil_servants(search_term, organization) }

    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let!(:brigitte) { create(:civil_servant, :full, :with_service, first_name: 'Brigitte', last_name: 'Stefenson') }
    let!(:maria) { create(:civil_servant, :full, first_name: 'Maria', last_name: 'Magdalena') }

    before do
      create(:service,
             civil_servant: maria,
             service_specification: service_specification,
             beginning: '2020-01-06',
             ending: '2020-01-31',
             civil_servant_agreed: false,
             civil_servant_agreed_on: nil,
             organization_agreed: true,
             organization_agreed_on: '2020-01-01')
    end

    context 'when there is no search term' do
      let(:search_term) { '' }

      it 'lists the first 20 of all civil servants' do
        expect(search_result).to contain_exactly(maria)
      end
    end

    context 'when there is a search term' do
      let(:search_term) { 'brig' }

      it 'lists the civil servants matching the search term' do
        expect(search_result).to be_empty
      end
    end
  end
end
