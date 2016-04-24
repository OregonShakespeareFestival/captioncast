require 'resque/server'

Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Resque::Server.new, at: "/resque"

  root 'cast#index'
  get 'cast/index'
  get 'cast/about'

  get 'display/select'
  post 'display/select'
  get 'display/index'
  get 'display/current'

  get 'upload/index'
  post 'upload/index'
  post 'upload/uploadFile'

  get 'operator/index'
  get 'operator/select'
  post 'operator/select'
  post 'operator/pushTextSeq'
  post 'operator/pushBlackout'

  post 'texts/toggleVis'

  resources :works, only: [:index, :edit, :destroy] do
    resources :texts, except: [:show]
  end

end
