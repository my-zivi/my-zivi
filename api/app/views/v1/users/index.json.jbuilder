# frozen_string_literal: true

json.array! @users, partial: 'shared/users/user', as: :user
