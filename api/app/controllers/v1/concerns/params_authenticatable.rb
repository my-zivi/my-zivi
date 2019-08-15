# frozen_string_literal: true

module V1
  module Concerns
    module ParamsAuthenticatable
      AUD_HEADER = Warden::JWTAuth.config.aud_header.upcase.tr('-', '_').freeze
      AUD_FIELD = ENV["HTTP_#{AUD_HEADER}"]

      def authenticate_from_params!
        user = Warden::JWTAuth::UserDecoder.new.call(token, :user, AUD_FIELD)
        sign_in :user, user
      rescue JWT::DecodeError
        raise AuthorizationError
      end

      private

      def token
        params.require(:token)
      end
    end
  end
end
