# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  namespace :civil_servants do
    get '/', to: 'overview#index'
  end

  namespace :organizations do
    get '/', to: 'overview#index'
  end
end
