# frozen_string_literal: true

module V1
  class UsersController < APIController
    include V1::Concerns::AdminAuthorizable

    before_action :set_user, only: :show
    before_action :protect_foreign_resource!, if: -> { current_user.civil_servant? }, only: :show
    before_action :authorize_admin!, only: :index

    def index
      @users = User.all
    end

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
