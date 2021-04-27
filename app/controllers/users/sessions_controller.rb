# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    after_action -> { flash.discard(:notice) }, only: %i[create destroy]
  end
end
