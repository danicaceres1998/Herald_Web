Rails.application.routes.draw do
  root 'herald#home'
  get 'tracked_billers', to: 'herald#show_tracked_billers'
  get 'untrack_billers', to: 'herald#show_list_for_untrack'
  resources :billers do
    # Functions for Herald
    get 'report_problem', to: 'herald#report_problem'
    get 'untrack_biller', to: 'herald#untrack_biller'
    # Functions for Brand
    post 'search_brands', to: 'brands#search_brands'
    get 'search_brands', to: 'brands#search_brands'
    post 'create_brand', to: 'brands#create'
    get 'create_brand', to: 'brands#create'
    get 'research_brand', to: 'brands#research_brand'
    post 'filter_products', to: 'brands#filter_products'
    get 'filter_products', to: 'brands#filter_products'
    post 'reselect_brand', to: 'brands#recreate_brand'
    get 'reselect_brand', to: 'brands#recreate_brand'
    resources :brands, except: [:create] do
      resources :products
    end
  end
  resources :emails
end
