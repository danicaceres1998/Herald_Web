Rails.application.routes.draw do
  root 'pages#home'
  resources :billers do
    post 'search_brands', to: 'brands#search_brands'
    get 'search_brands', to: 'brands#search_brands'
    post 'create_brand', to: 'brands#create'
    get 'create_brand', to: 'brands#create'
    get 'research_brand', to: 'brands#research_brand'
    resources :brands, except: [:create] do
      resources :products
    end
  end
  resources :emails
end
