# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :regional_centers, only: :index
    resources :holidays, only: %i[index create update destroy]
  end
end
