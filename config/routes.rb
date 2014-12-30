Rails.application.routes.draw do

  get 'upload/new'
  get 'upload/index'
  post 'upload/index'
  post 'upload/uploadFile'
  get 'display/index'
  get 'display/next'
  get 'display/previous'
  get 'display/current'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'cast#index'

  get 'cast/index'
  get 'cast/about'

  get 'operator/index'
  post 'operator/pushTextSeq'

  get 'editor/index'

end
