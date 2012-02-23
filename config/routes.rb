Eldorado::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  root :to => 'home#index'

  resources :articles
  resources :avatars do
    member do
      post 'select'
      post 'deselect'
    end
  end
  resources :categories do
    member do
      get 'confirm_delete'
    end
  end
  resources :comments
  resources :events
  resources :forums do
    member do
      get 'confirm_delete'
    end
  end
  resources :headers do
    member do
      post 'vote_up'
      post 'vote_down'
    end
  end
  resources :messages do
    collection do
      get 'more'
      get 'refresh'
    end
  end
  resources :posts do
    member do
      get 'quote'
      get 'topic'
      get 'vote_up'
      get 'vote_down'
    end
  end
  resources :ranks
  resources :settings
  resources :streams
  resources :subscriptions do
    collection do
      post 'toggle'
    end
  end
  resources :themes do
    member do
      post 'select'
      post 'deselect'
    end
  end
  resources :topics do
    member do
      get 'show_new'
    end
    collection do
      get 'mark_all_viewed'
    end
  end
  resources :uploads
  resources :upload_categories
  resources :users do
    member do
      post 'admin'
      get 'ban'
      post 'remove_ban'
      get 'confirm_delete'
    end
    resources :articles
    resources :posts
  end

  match 'search' => 'search#index'
  match 'refresh_chatters' => 'messages#refresh_chatters'

  match 'logout' => 'users#logout'
  match 'login' => 'users#login'
 # match 'register' => 'users#new'

  match 'admin' => 'settings#index'
  match 'blog' => 'articles#index'
  match 'blog/archives' => 'articles#archives'
  match 'chat' => 'messages#index'
  match 'files' => 'uploads#index'
  match 'forum' => 'forums#index'
  match 'help' => 'home#help'
  
  match '/auth/:provider/callback', to: 'users#steam_login'
  match '/auth/failure', to: 'users#steam_login_failure'
end
