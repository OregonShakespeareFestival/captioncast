require 'resque/server'

Rails.application.routes.draw do


  get 'display/select'
  post 'display/select'

  get 'upload/index'
  post 'upload/index'
  post 'upload/uploadFile'
  get 'display/index'
  get 'display/current'
  get 'display/blackout'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'cast#index'

  get 'cast/index'
  get 'cast/about'

  get 'operator/index'
  get 'operator/select'
  post 'operator/select'
  post 'operator/pushTextSeq'
  post 'operator/blackout'

  #for the editor view
  get 'texts/addBlank'
  post 'texts/addBlank'
  post 'texts/toggleVis'
  get 'texts/removeLine'
  post 'texts/removeLine'
  get 'texts/splitLine'
  post 'texts/splitLine'
  get 'texts/boldLine'
  post 'texts/boldLine'
  get 'texts/addLine'
  post 'texts/addLine'
  get 'works/deleteScript'
  post 'works/deleteScript'
  resources :works, only: [:index, :show, :edit] do
    resources :texts, only: [:index, :edit]
  end
  resources :texts
  #resources :works, only: [:index]
  # GET /works -> WorksController index

  mount Resque::Server.new, at: "/resque"
end
