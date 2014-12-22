Rails.application.routes.draw do

  get 'upload/new'


  get 'display/index'
  get 'display/next'
  get 'display/previous'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'cast#index'

  get 'cast/index'
  get 'cast/about'
end
