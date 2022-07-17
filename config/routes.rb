Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'

  post 'meeting_schedule_candidate/create'
  delete 'meeting_schedule_anchor/:id/destroy', to: 'meeting_schedule_anchor#destroy'
  post 'meeting_schedule_confirm/anchor/:anchor_id/candidate/:candidate_id/create', to: 'meeting_schedule_confirm#create'

  get 'home/index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :sessions, only: %i[create destroy]
  resources :home
end
