Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'stories#index'
  # get 'stories#index'

  resources :users do
    collection { post :block_unblock_user }
  end

  resources :stories, only: [:show]

  post 'comments/submit_comment', to: 'comments#submit_comment', as: :submit_comment
  post 'comments/approve_comment', to: 'comments#approve_comment', as: :approve_comment
  get 'comments/pending_approvals', to: 'comments#pending_approvals', as: :pending_approvals

end
