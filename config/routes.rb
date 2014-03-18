SSC::Application.routes.draw do
  #resources :setup, :only => [:page1, :page2, :page3, :page4, :page5]
  #resources :login, :only => [:page1, :page2, :page3]
  #root :to => redirect('/home/index')
  #TODO clean up 
  root 'home#index'

  get "setup/page1"
  get "setup/page2"
  get "setup/page3"
  get "setup/page4"
  get "setup/page5"
  put "setup/page1"
  post "setup/page1"
  post "setup/create"
  post "setup/page2"
  post "setup/page3"
  put "setup/page3"
  put "setup/page4"
  post "setup/page4"
  put "setup/page5"
  post "setup/page5"

  get "home/about"
  get "setup/show"

  get "login/page1"
  get "login/page2"
  get "login/page3"
  put "login/page1"
  put "login/page2"
  put "login/page3"

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
