Rails.application.routes.draw do
  get 'import_data', to: 'import_data#index'
  get 'financial_centralization', to: 'financial_centralization#index'
  get 'indirect_expenses', to: 'indirect_expenses#index'
  get 'stock', to: 'stock#index'
  resources :records
  resources :cars
  resources :january_solds
  resources :supplier_invoices
  resources :expense_values
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
