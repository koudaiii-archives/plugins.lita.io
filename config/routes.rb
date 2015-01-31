Rails.application.routes.draw do
  resources :plugins, only: :index

  root to: 'plugins#index'
end
