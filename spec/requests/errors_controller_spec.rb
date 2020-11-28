# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorsController, type: :request do
  describe '#unauthorized' do
    before { get unauthorized_path }

    it 'renders unauthorized page' do
      expect(response).to render_template 'errors/unauthorized'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#not_found' do
    before { get not_found_path }

    it 'renders not_found page' do
      expect(response).to render_template 'errors/not_found'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe '#internal_server_error' do
    before { get internal_server_error_path }

    it 'renders internal_server_error page' do
      expect(response).to render_template 'errors/internal_server_error'
      expect(response).to have_http_status(:internal_server_error)
    end
  end

  describe '#unprocessable_entity' do
    before { get unprocessable_entity_path }

    it 'renders unprocessable_entity page' do
      expect(response).to render_template 'errors/unprocessable_entity'
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
