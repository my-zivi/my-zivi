# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CivilServants::BaseController, type: :controller do
  controller do
    def index
      head :no_content
    end
  end

  context 'when a civil servant is authenticated' do
    subject { response }

    let(:civil_servant) { create :civil_servant, :full }

    before do
      sign_in civil_servant.user
      get :index
    end

    it { is_expected.to have_http_status(:no_content) }
  end

  context 'when no one is authenticated' do
    before { get :index }

    it { is_expected.to redirect_to new_user_session_path }
  end
end
