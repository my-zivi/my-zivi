# frozen_string_literal: true

module Devise
  class CustomFailure < ::Devise::FailureApp
    # Redirect pdf request types to the login page
    def skip_format?
      %w[pdf */*].include? request_format.to_s
    end
  end
end
