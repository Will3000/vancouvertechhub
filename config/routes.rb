Rails.application.routes.draw do


  resources :users, only: [:new, :create, :edit, :update, :destroy]

  # scope module: 'users': will generate the path without /users, but with
  # the child controllers in the users folder
  scope module: 'users' do
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :password_changes, only: [:edit, :update]
    resources :account_verifications, only: [:new, :create, :edit]
  end

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :organizations do
    resources :claim_requests
    resources :media_contents, only: [:create]
  end
  # ajax action for organization filter on directory page
  post "/organizations/filter" => "organizations#filter"

  resources :news, only: [:index]
  get "/news/search_news" => "news#search_news"
  resources :news_filters, only: [:create, :destroy]

  resources :technologies

  root "organizations#index"

  resources :events

  get "/about"                => "home#about"

  get "/admin/organizations"  => "admin#organizations",
                              as: :admin_organizations

  get "/admin/events"         => "admin#events",
                              as: :admin_events

  get "/admin/users"          => "admin#users",
                              as: :admin_users

  post "/admin/users"         => "admin#users"

  get "/admin/technologies"   => "admin#technologies",
                              as: :admin_technologies
  get "/admin/news_filters"   => "admin#news_filters",
                              as: :admin_news_filters


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
