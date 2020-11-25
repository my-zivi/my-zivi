# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServantServiceAgreementSearch, type: :service do
  describe '#filtered_all_civil_servants' do
    subject(:search_result_ids) { described_class.filtered_all_civil_servants(search_term).map(&:id) }

    let!(:brigitte) do
      create(:civil_servant, :full,
             :with_service, first_name: 'Brigitte',
                            last_name: 'Aliennachnamensindlang', user: brigitte_user)
    end
    let(:brigitte_user) { build :user, email: 'brigitte@gmail.com' }

    let!(:peter) do
      create(:civil_servant, :full, :with_service,
             first_name: 'Peter', last_name: 'Hugebtobler', user: peter_user)
    end
    let(:peter_user) { build :user, email: 'peter@bluewin.ch' }

    let!(:paul) do
      create(:civil_servant, :full, :with_service,
             first_name: 'Paul', last_name: 'Alien', user: paul_user)
    end
    let(:paul_user) { build :user, email: 'palien@gmail.com' }

    let!(:birgitte) do
      create(:civil_servant, :full, first_name: 'Birgitte', last_name: 'Magdalena', user: birgitte_user)
    end
    let(:birgitte_user) { build :user, email: 'b.magdalena@outlook.com' }

    context 'when there is no search term' do
      let(:search_term) { '' }

      it 'lists the first 20 of all civil servants' do
        expect(search_result_ids).to eq([birgitte, brigitte, paul, peter].map(&:id))
      end
    end

    context 'when there is a search term' do
      context 'when the search term is part of the first name' do
        context 'when the search term only matches one civil servant' do
          let(:search_term) { 'brig' }

          it 'lists the civil servant matching the search term' do
            expect(search_result_ids).to eq([brigitte].map(&:id))
          end
        end

        context 'when the search term matches multiple civil servants' do
          let(:search_term) { 'gitte' }

          it 'lists the civil servants matching the search term' do
            expect(search_result_ids).to contain_exactly(birgitte.id, brigitte.id)
          end
        end
      end

      context 'when the search term is part of the last name' do
        context 'when the search term only matches one civil servant' do
          let(:search_term) { 'Hugebtobler' }

          it 'lists the civil servant matching the search term' do
            expect(search_result_ids).to eq([peter].map(&:id))
          end
        end

        context 'when the search term matches multiple civil servants' do
          let(:search_term) { 'Alien' }

          it 'lists the civil servants matching the search term' do
            expect(search_result_ids).to eq([paul, brigitte].map(&:id))
          end
        end
      end

      context 'when the search term is part of the email' do
        context 'when the search term only matches one civil servant' do
          let(:search_term) { 'outlook.com' }

          it 'lists the civil servant matching the search term' do
            expect(search_result_ids).to eq([birgitte].map(&:id))
          end
        end

        context 'when the search term matches multiple civil servants' do
          let(:search_term) { 'gmail.com' }

          it 'lists the civil servants matching the search term' do
            expect(search_result_ids).to eq([paul, brigitte].map(&:id))
          end
        end
      end
    end
  end

  describe '#filtered_organization_civil_servants' do
    subject(:search_result) { described_class.filtered_organization_civil_servants(search_term, organization) }

    let(:organization) { create :organization }
    let(:service_specification) { create :service_specification, organization: organization }

    let!(:maria) { create(:civil_servant, :full, first_name: 'Maria', last_name: 'Magdalena') }

    before do
      create(:civil_servant, :full, :with_service, first_name: 'Brigitte', last_name: 'Stefenson')
      create(:service,
             civil_servant: maria,
             service_specification: service_specification,
             beginning: '2020-01-06',
             ending: '2020-01-31',
             civil_servant_agreed: false,
             civil_servant_decided_at: nil,
             organization_agreed: true,
             organization_decided_at: '2020-01-01')
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
