# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :request do
  shared_examples_for 'can access home page' do
    it 'returns http success' do
      get path
      expect(response).to have_http_status(:success)
      expect(response.body).not_to be_empty
    end
  end

  describe '#index' do
    it_behaves_like 'can access home page' do
      let(:path) { root_path }
    end
  end

  %w[administration recruiting agb privacy_policy about_us].each do |route|
    describe "##{route}" do
      it_behaves_like 'can access home page' do
        let(:path) { public_send(:"#{route}_path") }
      end
    end
  end
end
