Rails.application.routes.draw do
  root 'pages#home'
  resources :billers do
    post 'search_brands', to: 'brands#search_brands'
    get 'search_brands', to: 'brands#search_brands'
    resources :brands do
      resources :products
    end
  end
  resources :emails
end
