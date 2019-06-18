# frozen_string_literal: true

module V1
  class UsersController < APIController
    before_action :set_user
    before_action :protect_foreign_resource!, if: -> { current_user.civil_servant? }

    def show
      render partial: 'shared/users/user', locals: { user: @user }
    end

    private

    def set_user
      @user = User.find(params.require(:id))
    end

    def protect_foreign_resource!
      raise AuthorizationError unless current_user.id == @user.id
    end
  end
end
