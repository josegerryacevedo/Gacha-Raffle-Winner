Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root to: 'users/home#index', as: :client_root
    namespace :users do
      get 'invite-people', to: 'invite_people#invite_qr'
      resource :profile
      resources :addresses
      resources :lotteries
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins, path: '' do
      root to: 'home#index', as: :admin_root
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users
      resources :items do
        put :start, :pause, :cancel, :end
      end
      resources :categories
      resources :bets, only: :index do
        put :cancel
      end
      resources :winners, only: :index do
        put :submit, :pay, :ship, :deliver, :publish, :remove_publish
      end
      resources :offers
    end
  end
end
