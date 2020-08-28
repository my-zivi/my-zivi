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
    get 'planning', to: 'planning#index'

    resources :organization_members, as: 'members', only: %i[index edit update destroy]
    resources :service_specifications, except: :show
    resources :payments, only: %i[index show update destroy]
    resources :expense_sheets, except: :show
    resources :civil_servants, only: %i[index show] do
      resources :services, only: :show
    end
  end
end
