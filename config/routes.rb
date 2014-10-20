Rails.application.routes.draw do

  root 'home#index'
  get '/home/series', to: 'home#series', as: :home_series
  get '/home/airingtoday', to: 'home#airingtoday', as: :home_airingtoday
  get '/home/externalids', to: 'home#externalids', as: :home_externalids
  get '/mychannels', to: 'channel#mychannels', as: :mychannels
  get '/browse', to: 'channel#browse', as :browse
  resources :home
  devise_for :users
  devise_scope :user do
    get "signup", to: "devise/registrations#new"
    get "login", to: "devise/sessions#new"
    get "logout", to: "devise/sessions#destroy"
  end

end
