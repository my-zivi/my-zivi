# frozen_string_literal: true

module Devise
  class CustomFailure < ::Devise::FailureApp
    # Redirect pdf request types to the login page
    def skip_format?
      %w[html turbo_stream pdf */*].include? request_format.to_s
    end

    def respond
      if request_format == :turbo_stream
        redirect
      else
        super
      end
    end
  end
end
