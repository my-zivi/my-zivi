# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    user_comp = ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(username),
      ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])
    )

    pass_comp = ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(password),
      ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD'])
    )

    user_comp & pass_comp
  end
end

Rails.application.routes.draw do
  root 'home#index'
  mount Sidekiq::Web, at: '/sidekiq' if defined? Sidekiq::Web

  devise_for :users, controllers: { invitations: 'users/invitations' }

  resource :mailing_list, only: :create
  resources :expense_sheets, only: :show

  namespace :civil_servants do
    get '/', to: 'overview#index'

    resource :civil_servant, only: %i[edit update], on: :collection
    resources :service_agreements, only: :index do
      patch 'accept', to: 'service_agreements#accept'
      patch 'decline', to: 'service_agreements#decline'
    end
    resources :services, only: %i[index show]

    get 'register', to: 'registrations#edit'
    patch 'register', to: 'registrations#update'
  end

  namespace :organizations do
    get '/', to: 'overview#index'

    resources :organization_members, as: 'members', except: :show
    resources :service_specifications, except: :show
    resources :service_agreements, only: %i[index destroy create new]
    get '/service_agreements/civil_servants/search',
        to: 'service_agreements#search', as: 'service_agreement_civil_servant_search'
    resources :payments, except: :edit
    resources :expense_sheets, except: :show
    get '/phone_list', to: 'phone_list#index', as: 'phone_list'
    get '/phone_list/:name', to: 'phone_list#index', as: 'named_phone_list'
    resources :services, only: :index
    resources :civil_servants, only: %i[index show] do
      resources :services, only: %i[show edit update]
    end
  end

  get '/401' => 'errors#unauthorized', as: :unauthorized
  get '/404' => 'errors#not_found', as: :not_found
  get '/500' => 'errors#internal_server_error', as: :internal_server_error
  get '/422' => 'errors#unprocessable_entity', as: :unprocessable_entity
end
