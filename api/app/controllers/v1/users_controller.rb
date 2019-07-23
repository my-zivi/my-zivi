# frozen_string_literal: true

module V1
  class UsersController < APIController
    include V1::Concerns::AdminAuthorizable

    before_action :set_user, only: %i[show update destroy]
    before_action :protect_foreign_resource!, only: %i[show update], if: -> { current_user.civil_servant? }
    before_action :authorize_admin!, only: %i[index destroy]
    before_action :protect_self_deletion!, only: :destroy

    def index
      @users = User.all
    end

    def show
      render partial: 'shared/users/user', locals: { user: @user }
    end

    def destroy
      raise ValidationError, @user.errors unless @user.destroy
    end

    def update
      raise ValidationError, @user.errors unless @user.update(user_params)

      show
    end

    private

    def set_user
      @user = User.find(params.require(:id))
    end

    def protect_foreign_resource!
      raise AuthorizationError unless current_user.id == @user.id
    end

    def protect_self_deletion!
      return unless @user.id == current_user.id

      raise ValidationError, base: I18n.t('activerecord.errors.models.user.attributes.base.cant_delete_himself')
    end

    def user_params
      params.require(:user).permit(*::Concerns::DeviseUserParamsRegistrable::PERMITTED_USER_KEYS)
    end
  end
end
