Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'stories#index'

  resources :users, only: [:index] do
    collection { post :block_unblock_user }
  end

  resources :stories, only: [:show]
  post 'comments/submit_comment', to: 'comments#submit_comment', as: :submit_comment
  post 'comments/approve_comment', to: 'comments#approve_comment', as: :approve_comment
  get 'comments/pending_approvals', to: 'comments#pending_approvals', as: :pending_approvals

end
