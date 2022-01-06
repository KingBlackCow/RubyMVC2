Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "email#index"
  post '/auth' => 'email#authenticate_send_email'
  post '/auth_check' => 'email#authenticate_check'
  get '/send' => 'email#send_email'
end
