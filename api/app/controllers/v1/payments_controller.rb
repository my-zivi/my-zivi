# frozen_string_literal: true

module V1
  class PaymentsController < ApplicationController
    before_action :authenticate_from_params!

    def export
      sheets = ExpenseSheet.includes(:user).ready_for_payment
      render plain: PainGenerationService.new(sheets).generate_pain.to_xml('pain.001.001.03.ch.02'), content_type: :xml
    end

    private

    def authenticate_from_params!
      user = Warden::JWTAuth::UserDecoder.new.call(token, :user, aud)
      sign_in :user, user
    rescue JWT::DecodeError
      raise AuthorizationError
    end

    def token
      params.require(:token)
    end

    def aud
      ENV["HTTP_#{aud_header}"]
    end

    def aud_header
      Warden::JWTAuth.config.aud_header.upcase.tr('-', '_')
    end
  end
end
