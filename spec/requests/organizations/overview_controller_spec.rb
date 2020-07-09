# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::OverviewController, type: :request do
  let(:organization) { create :organization }

  context 'when signed in as an organization administrator' do
    let(:organization_administrator) { create :organization_member, organization: organization }

    before { sign_in organization_administrator.user }

    describe '#index' do
      before { get organizations_path }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
