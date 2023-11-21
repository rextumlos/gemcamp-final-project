Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    root "client/home#index", as: :client_root

    devise_for :users, as: :client, controllers: {
      sessions: 'client/users/sessions',
      registrations: 'client/users/registrations'
    }

    get "/me", to: 'client/me#index'
    get "/invite", to: 'client/invite#index'

    resources 'client/address', as: 'address', path: 'address', except: [:show, :edit]
    resources 'client/lottery', as: 'lottery', path: 'lottery', only: [:index, :show]
    resources 'client/tickets', as: 'submit_tickets', path: 'submit_tickets', only: [:create]
    resources 'client/shop', as: 'shop', path: 'shop', only: [:index, :show]
    resources 'client/orders', as: 'purchase_orders', path: 'purchase_orders', only: [:create]

    resources 'client/me/orders', as: 'order_history', path: 'me/orders', only: :index
    resources 'client/me/lotteries', as: 'lottery_history', path: 'me/lotteries', only: :index
  end

  constraints(AdminDomainConstraint.new) do
    root "admin/home#index", as: :admin_root

    devise_for :users, as: :admin, controllers: {
      sessions: 'admin/users/sessions'
    }, skip: [:registrations, :passwords]

    resources 'admin/items', as: 'items', path: 'items'
    resources 'admin/categories', as: 'categories', path: 'categories', except: [:show]
    resources 'admin/tickets', as: 'tickets', path: 'tickets', only: [:index, :update]
    resources 'admin/winners', as: 'winners', path: 'winners', only: [:index, :update]
    resources 'admin/offers', as: 'offers', path: 'offers'
    resources 'admin/orders', as: 'orders', path: 'orders', only: [:index, :update]
  end

  namespace :api do
    namespace :v1 do
      resources :regions, only: [:index, :show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: [:index, :show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: [:index, :show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: [:index, :show], defaults: { format: :json }
    end
  end
end
