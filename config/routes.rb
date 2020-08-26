# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  resource :mailing_list, only: :create
  resources :expense_sheets, only: :show

  namespace :civil_servants do
    get '/', to: 'overview#index'

    resource :civil_servant, only: %i[edit update], on: :collection
    resources :services, only: %i[index show]
  end

  namespace :organizations do
    get '/', to: 'overview#index'

    resources :organization_members, as: 'members', only: %i[index edit update destroy]
    resources :service_specifications, except: :show
    resources :expense_sheets, except: :show
    resources :civil_servants, only: %i[index show] do
      resources :services, only: :show
    end
  end
end
