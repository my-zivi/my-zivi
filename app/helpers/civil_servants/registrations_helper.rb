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
      class_name = [
        'nav-link',
        'font-weight-semi-bold',
        step_link_state_class(step_identifier, current_registration_step)
      ].join(' ')

      if compare_with_current_registration_step(step_identifier, current_registration_step).negative?
        link_to(civil_servants_register_path(displayed_step: step_identifier), class: class_name, &block)
      else
        tag.div(capture(&block), class: "#{class_name} user-select-none")
      end
    end

    private

    def compare_with_current_registration_step(step_identifier, current_registration_step)
      RegistrationStep.new(identifier: step_identifier) <=> current_registration_step
    end

    def step_link_state_class(step_identifier, current_registration_step)
      comparison = compare_with_current_registration_step(step_identifier, current_registration_step)

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
