Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  post '/authenticate', to: 'authentications#auth'
  post '/signup',       to: 'signup#signup'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
