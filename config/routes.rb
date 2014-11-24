# Bryant Chang
# Renjie Long
Rails.application.routes.draw do

  root 'home#index'
  get '/home/series', to: 'home#series', as: :home_series
  get '/home/airingtoday', to: 'home#airingtoday', as: :home_airingtoday
  get '/home/externalids', to: 'home#externalids', as: :home_externalids
  get '/mychannels', to: 'channel#mychannels', as: :mychannels
  get '/browse', to: 'channel#browse', as: :browse
  get '/browse/next_page', to: 'channel#next_page', as: :next_page
  get '/browse/previous_page', to: 'channel#previous_page', as: :previous_page
  get '/browse/browse_list', to: 'channel#browse_list', as: :browse_list
  get '/browse/search', to: 'channel#search', as: :serach
  get '/browse/:id', to: 'channel#details', as: :browse_details
  get '/channel/:id', to: 'channel#room', as: :channel_room
  post '/channel/follow', to: 'channel#follow', as: :channel_follow
  post '/channel/unfollow', to: 'channel#unfollow', as: :channel_unfollow
  post '/channel/:id/post', to: 'channel#post', as: :channel_post
  get '/channel/:id/messages', to: 'channel#messages', as: :channel_messages
  get '/find/', to: 'channel#find', as: :channel_find
  get '/channel/check_following/:id', to: 'channel#check_following', as: :channel_check_following
  post '/channel/add_active', to: 'channel#add_active', as: :channel_add_active
  post '/channel/delete_active', to: 'channel#delete_active', as: :channel_delete_active
  get '/channel/active/:id', to: 'channel#user_list', as: :channel_active
  post '/channel/update_active', to: 'channel#update_active', as: :channel_update_active
  post '/channel/:id/add_topic', to: 'channel#add_topic', as: :channel_add_topic
  get '/channel/:id/topics', to: 'channel#topics', as: :channel_get_topics
  get '/channel/:id/:topic_name/user_count', to: 'channel#user_count', as: :channel_user_count
  get '/channel/:id/messages/:topic', to: 'channel#messages_for_topic', as: :channel_message_for_topic
  # get '/channel/:id/topics_for_user', to: 'channel#topics_for_user', as: :channel_topics_for_user

  resources :home
  
  devise_for :users
  devise_scope :user do
    get "signup", to: "devise/registrations#new"
    get "login", to: "devise/sessions#new"
    get "logout", to: "devise/sessions#destroy"
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get '/test', to: 'channel#index', as: :test
  post '/test/post',to: 'channel#submit', as: :messages

end
