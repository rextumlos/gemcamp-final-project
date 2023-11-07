Rails.application.routes.draw do
  devise_for :users, as: :client, path: 'client', controllers: {
    sessions: 'client/users/sessions',
    registrations: 'client/users/registrations'
  }

  devise_for :users, as: :admin, path: 'admin', controllers: {
    sessions: 'admin/users/sessions'
  }, skip: [:registrations, :passwords]

  namespace :admin do
    root "home#index"
  end

  namespace :client do
    root "home#index"
  end
end
