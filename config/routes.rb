BaseballApp::Application.routes.draw do
  devise_for :users

  root to: "players#index"

  resources :players
  resources :batting_stats
  resources :batting_projections
  resources :leagues
  resources :notes
end
