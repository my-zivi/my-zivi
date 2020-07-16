# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  namespace :civil_servants do
    get '/', to: 'overview#index'
    get 'civil_servant/show'
    get 'civil_servant/edit'
    get 'civil_servant/update'
  end

  namespace :organizations do
    get '/', to: 'overview#index'

    resources :organization_members, as: 'members', only: %i[index edit update destroy]
  end
end
