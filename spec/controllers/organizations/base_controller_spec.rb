# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::BaseController, type: :controller do
  controller do
    skip_authorization_check :index

    def index
      head :no_content
    end
  end

  context 'when an organization administrator is authenticated' do
    subject { response }

    let(:organization_admin) { create(:organization_member) }

    before do
      sign_in organization_admin.user
      get :index
    end

    it { is_expected.to have_http_status(:no_content) }
  end

  context 'when no one is authenticated' do
    before { get :index }

    it { is_expected.to redirect_to new_user_session_path }
  end
end
