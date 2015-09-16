Rails.application.routes.draw do
  get 'login' => 'user_sessions#new'
  get 'usersessions/github' => 'user_sessions#github'
  get 'usersessions/github/callback' => 'user_sessions#github_callback'
  get 'usersessions/stackex' => 'user_sessions#stackex'
  get 'usersessions/stackex/callback' => 'user_sessions#stackex_callback'

  get 'users/new'
  get 'users/:id' => 'users#show', as: :user

  get 'se_auth/callback'

  get 'gh_auth/callback'

  get 'gh_auth/sign_in'

  get 'snippets/show'

  get 'profiles/public'

  get 'profiles/private'

  get 'search/index'

  get 'auth/sign_in'

  get 'auth/sign_up'

  get 'semantic/benefits'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Authentication routes
  get 'sign-in' => 'auth#sign_in'
  get 'sign-up' => 'auth#sign_up'

  # Semantic routes
  get 'semantic' => 'semantic#benefits'

  # Search routes
  get 'search' => 'search#index'

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
