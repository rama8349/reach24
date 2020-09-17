Rails.application.routes.draw do
  # get 'short_url/index'
  root :to => 'short_urls#index'

  resources :short_urls
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
