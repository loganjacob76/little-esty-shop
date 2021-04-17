Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#welcome'

  get '/merchant/:merchant_id/dashboard', to: 'merchants#dashboard', as: 'merchant_dashboard'

  resources :merchants, only: [:show, :create] do
     resources :invoices, only: [:index, :show]
     resources :items
     resources :dashboard, only: [:index]
   end

  namespace :admin do
    resources :invoices
    resources :merchants do
      member do
        patch :toggle_enabled
      end
    end
  end

  resources :admin, only: [:index]
end
