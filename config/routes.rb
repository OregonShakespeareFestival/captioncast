require 'resque/server'

Rails.application.routes.draw do
  resources :works, only: [:index]
  # GET /works -> WorksController index

  get 'display/select'
  post 'display/select'

  get 'upload/index'
  post 'upload/index'
  post 'upload/uploadFile'
  get 'display/index'
  get 'display/current'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'cast#index'

  get 'cast/index'
  get 'cast/about'

  get 'operator/index'
  get 'operator/select'
  post 'operator/select'
  post 'operator/pushTextSeq'

  get 'editor/index'

  mount Resque::Server.new, at: "/resque"
end
