require 'resque/server'

Rails.application.routes.draw do

  get 'preview/index'
  post 'preview/index'

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
  post 'operator/pushBlackout'

  #for the editor view
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
  post 'works/select'
  resources :works, only: [:index, :show, :edit] do
    resources :texts, only: [:index, :edit, :new]
  end
  resources :texts

  #get 'texts/_edit'

  #resources :works, only: [:index]
  # GET /works -> WorksController index

  mount Resque::Server.new, at: "/resque"
end
