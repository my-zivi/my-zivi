# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  namespace :civil_servants do
    get '/', to: 'overview#index'

    resource :civil_servant, only: %i[edit update], on: :collection
    resources :services, only: %i[index show]
  end

  namespace :organizations do
    get '/', to: 'overview#index'

    resources :organization_members, as: 'members', only: %i[index edit update destroy]
    resources :service_specifications, except: :show
  end
end
