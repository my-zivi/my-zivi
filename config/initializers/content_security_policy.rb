# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src :self, :https, :data
  policy.img_src :self, :https, :data
  policy.object_src :none
  policy.script_src :self, :https, :unsafe_inline, :unsafe_eval

  # You may need to enable this in production as well depending on your setup.
  #    policy.script_src *policy.script_src, :blob if Rails.env.test?

  policy.style_src :self, :https, :unsafe_inline

  # Allow @vite/client to hot reload style changes in development
  # Allow @vite/client to hot reload javascript changes in development
  # Allow @vite/client to hot reload changes in development
  if Rails.env.development?
    policy.style_src(*policy.style_src, :unsafe_inline)

    policy.script_src(
      *policy.script_src, :unsafe_eval, "http://#{ViteRuby.config.host_with_port}"
    )

    policy.connect_src(
      *policy.connect_src, "ws://#{ViteRuby.config.host_with_port}"
    )
  end

  # Specify URI for violation reports
  policy.report_uri ENV['CSP_REPORT_URI'] if ENV['CSP_REPORT_URI']
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }

# Set the nonce only to specific directives
# Rails.application.config.content_security_policy_nonce_directives = %w(script-src)

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
