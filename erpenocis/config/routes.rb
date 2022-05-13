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
  resources :project_costs do
    member do
      patch :update
      patch :edit, to: "project_costs#update"
    end
  end
  resources :project_situations
  resources :invoices 
  resources :orders do
    member do
      patch :move
      put :move
      get :move_order
      patch :move_order, to: "orders#move"
    end
  end
  resources :suppliers
  resources :employees
  resources :projects do
    member do
      patch :update_project_costs
      put :update_project_costs
      get :add_project_costs
    end
  end
  get '/index_project_costs', to: 'projects#index_project_costs', as: 'index_project_costs'
  
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
