Rails.application.routes.draw do
  devise_for :users
  

  get '/auth', to: 'authentications#show'
  get '/authsession', to:'authentications#thoushaltnotbenamed'
  post '/authenticate', to: 'authentications#request1'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end