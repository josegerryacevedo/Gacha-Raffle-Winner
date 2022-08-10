Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    root to:  'users/home#index', as: :client_root
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    namespace :users do
      resource :profile
      resources :addresses
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins , path: '' do
      root to: 'home#index'
      devise_for :users, controllers: { sessions: 'admins/sessions' }
    end
  end
end
