Istockhub::Application.routes.draw do
  get "derivatives/index"
  get "stocks/index"
  get "watchlist/index"
  resources :relationships
  get "usertags/:usertag",   to: "usertags#show",      as: :usertag
  get "usertags",            to: "usertags#index",     as: :usertags
  get "hashtags/:hashtag",   to: "hashtags#show",      as: :hashtag
  get "hashtags",            to: "hashtags#index",     as: :hashtags
  get "stock/:moneytag",  to: "moneytags#show",     as: :moneytag
  get "stocks",           to: "moneytags#index",    as: :moneytags
  resources :postings
  get '/:id/following', :to => 'profiles#following', as: :following   
  get '/:id/followers', :to => 'profiles#followers', as: :followers
  
  devise_for :users
  # resources  :profiles, :only => [:index, :show] do
  #   member do
  #     get :following, :followers
  #   end
  # end

  scope :api do
    resources :stocks, defaults: {format: :json} do
      get :ohlc
    end
    get :derivatives, to: 'derivatives#index'
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  get "profiles/show"

  devise_scope :user do
    get '/register', to: 'devise/registrations#new', as: :register
    get '/login', to: 'devise/sessions#new', as: :login
    get '/logout', to: 'devise/sessions#destroy', as: :logout
    get '/edit', to: 'devise/registrations#edit', as: :edit
  end

  authenticated :user do
    devise_scope :user do
      root to: "profiles#show", :as => "authenticated"
    end
  end

  unauthenticated do
    devise_scope :user do
      root to: "devise/sessions#new", :as => "unauthenticated"
    end
  end

  get ':id' => 'profiles#show', as: :profile
  # You can have the root of your site routed with "root"
  # root 'devise/sessions#new'

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
