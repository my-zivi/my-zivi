# frozen_string_literal: true

Rails.application.routes.draw do
  scope :v1 do
    devise_scope :user do
      post 'users/validate', to: 'devise_overrides/registrations#validate', defaults: { format: :json }
    end
    devise_for :users, defaults: { format: :json }, controllers: {
      registrations: 'devise_overrides/registrations'
    }
  end

  namespace :v1, defaults: { format: :json } do
    resources :regional_centers, only: :index
    resources :holidays, only: %i[index create update destroy]
    resources :service_specifications, only: %i[index create update], param: :identification_number
    resources :payments, except: :update, param: :payment_timestamp
    resources :users, except: :create
    resources :expense_sheets do
      get 'hints', on: :member
    end

    resources :services do
      collection do
        get 'calculate_service_days', to: 'service_calculator#calculate_service_days'
        get 'calculate_ending', to: 'service_calculator#calculate_ending'
      end
    end

    get 'phone_list', to: 'phone_list#show', as: 'phone_list_export'
    get 'expense_sheet', to: 'expense_sheets#show', as: 'expense_sheet_export'

    put 'payments/:payment_timestamp/confirm', to: 'payments#confirm', as: 'payment_confirm'
  end
end
