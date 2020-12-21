# frozen_string_literal: true

module Users
  class RegistrationsController < DeviseInvitable::RegistrationsController
    include PortalHelper

    # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action -> { authorize! :access, current_portal }, only: %i[edit update]
    # rubocop:enable Rails/LexicallyScopedActionFilter

    layout :layout_name

    private

    def layout_name
      # noinspection RubyCaseWithoutElseBlockInspection
      case current_portal
      when :organization_portal
        'organizations/application'
      when :civil_servant_portal
        'civil_servants/application'
      end
    end
  end
end
