Rails.application.routes.draw do
  resources :expenses
  resources :employee_salaries
  resources :project_costs
  resources :project_situations
  resources :invoices
  resources :orders
  resources :suppliers
  resources :employees
  resources :projects
  devise_for :users, controllers:{registrations:'registrations'}
  resources :users
  get '/settings', to: 'users#settings', as: 'settings'
  resource :user, only: [:settings] do
    collection do
      patch 'update_settings'
    end
  end
  root 'dashboard#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
