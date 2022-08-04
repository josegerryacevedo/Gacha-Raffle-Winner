Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    root :to => 'home#index', as: :client_root
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins, path: '' do
      root :to => 'home#index'
      devise_for :users, controllers: { sessions: 'admins/sessions' }
    end
  end
end
