# frozen_string_literal: true

module CivilServants
  module RegistrationsHelper
    STEP_ICONS = {
      personal: 'fa-user',
      address: 'fa-envelope',
      bank_and_insurance: 'fa-university',
      service_specific: 'fa-info'
    }.freeze

    def step_icon(step_identifier)
      tag.i(class: "fas #{STEP_ICONS[step_identifier]}")
    end

    def step_link(step_identifier, current_registration_step, &block)
      class_name = "nav-link font-weight-semi-bold #{step_link_state_class(step_identifier, current_registration_step)}"

      link_to('#', class: class_name.strip, &block)
    end

    private

    def step_link_state_class(step_identifier, current_registration_step)
      comparison = RegistrationStep.new(identifier: step_identifier) <=> current_registration_step

      if comparison.negative?
        'done'
      elsif comparison.zero?
        'active'
      else
        ''
      end
    end
  end
end
