Rails.application.routes.draw do

# users routes
  get 'users/:password' => 'users#index'

  post 'register' => 'users#register'
  post 'login' => 'users#login'
  post 'find_password' => 'users#find_password'

  post 'upload_avatar' => 'users#upload_avatar'
  post 'change_username' => 'users#change_username'

  get 'books_by_user/:user_id' => 'users#get_books_by_user', :as => :get_books
  get 'friends_by_user/:user_id' => 'users#get_friends_by_user', :as => :get_friends


# books routes
  get 'books/:password' => 'books#index'

  post 'add_book' => "books#create"
  put 'remove_book' => "books#remove"
  put 'change_status' => "books#update"

  get 'friendsWithBook/:douban_book_id/forUser/:user_id' => 'books#get_friends_with_book_for_user', :as => :get_users

# groups routes
  get 'groups/:password' => 'groups#index'


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
