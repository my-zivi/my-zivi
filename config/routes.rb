# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  namespace :civil_servants do
    get 'overview', to: 'overview#index'
  end
end
