# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :regional_centers, only: :index
    resources :holidays, only: %i[index create update destroy]
    resources :service_specifications, only: %i[index create update]
    resources :expense_sheets
    resources :services
  end

  scope :v1 do
    devise_for :users, defaults: { format: :json }
  end
end
