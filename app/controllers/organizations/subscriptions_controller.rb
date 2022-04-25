# frozen_string_literal: true

module Organizations
  class SubscriptionsController < BaseController
    def index
      breadcrumb 'organizations.subscriptions.index', :organizations_subscriptions_path

      @subscriptions = current_organization.subscriptions
    end

    def self_sign_up

    end
  end
end

