Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }


  post '/authenticate', to: 'authentications#auth'
  post '/signup',       to: 'signup#signup'

  devise_scope :user do
    post '/login', to: 'devise/sessions#create'
    get '/login',  to: 'devise/sessions#new'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
