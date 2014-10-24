Rails.application.routes.draw do

  root 'home#index'
  get '/home/series', to: 'home#series', as: :home_series
  get '/home/airingtoday', to: 'home#airingtoday', as: :home_airingtoday
  get '/home/externalids', to: 'home#externalids', as: :home_externalids
  get '/mychannels', to: 'channel#mychannels', as: :mychannels
  get '/browse', to: 'channel#browse', as: :browse
  get '/channel/:id', to: 'channel#room', as: :channel_room
  post '/channel/:id/follow', to: 'channel#follow', as: :channel_follow
  post '/channel/:id/unfollow', to: 'channel#unfollow', as: :channel_unfollow
  post '/channel/:id/post', to: 'channel#post', as: :channel_post
  get '/channel/:id/messages', to: 'channel#messages', as: :channel_messages
  
  get '/channel/find/', to: 'channel#find', as: :channel_find

  resources :home
  devise_for :users
  devise_scope :user do
    get "signup", to: "devise/registrations#new"
    get "login", to: "devise/sessions#new"
    get "logout", to: "devise/sessions#destroy"
  end

  get '/test', to: 'channel#index', as: :test
  post '/test/post',to: 'channel#submit', as: :messages

end
