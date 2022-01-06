Rails.application.routes.draw do
  resources :users
  get 'home/index'
  root 'home#index'

  post '/auth' => 'email#authenticate_send_email'
  post '/auth_check' => 'email#authenticate_check'
  get '/send' => 'email#send_email'
  get '/send2' => 'email#send_emailer'
  get 'home/index'
end
