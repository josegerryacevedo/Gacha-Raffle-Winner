Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    root to:  'users/home#index', as: :client_root
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    namespace :users do
      get 'lottery', to: 'lotteries#lottery'
      get 'invite-people', to: 'invite_people#invite_qr'
      resource :profile
      resources :addresses
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins , path: '' do
      root to: 'home#index', as: :admin_root
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users
      resources :items, only: :index
      resources :categories, only: :index
    end
  end
end
