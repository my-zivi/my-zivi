# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServantParamsModifier, type: :service do
  describe '#call' do
    subject(:modified_params) { described_class.call(ActionController::Parameters.new(params)) }

    let(:params) { { iban: ' CH56 0483 5012 3456 7800 9' } }

    it 'removes whitespaces from iban' do
      expect(modified_params[:iban]).to eq 'CH5604835012345678009'
    end

    context 'when iban is not present' do
      let(:params) { {} }

      it 'does not touch iban' do
        expect(modified_params[:iban]).not_to be_present
      end
    end
  end
end
