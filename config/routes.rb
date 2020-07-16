# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  namespace :civil_servants do
    get '/', to: 'overview#index'

    resource :civil_servant, only: %i[edit update], on: :collection
  end

  namespace :organizations do
    get '/', to: 'overview#index'

    resources :organization_members, as: 'members', only: %i[index edit update destroy]
  end
end
