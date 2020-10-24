# frozen_string_literal: true

module CivilServants
  module Concerns
    module AuthenticableAndAuthorizable
      extend ActiveSupport::Concern

      included do
        before_action :authenticate_user!

        check_authorization
      end
    end
  end
end
