SSC::Application.routes.draw do
  #resources :setup, :only => [:page1, :page2, :page3, :page4, :page5]
  #resources :login, :only => [:page1, :page2, :page3]
  #root :to => redirect('/home/index')
  #TODO clean up 
  root 'home#index'


resources :setup do
  get "basicinfo", :on => :collection
  post "basicinfo", :on => :collection
  get "addressinfo", :on => :collection
  post "addressinfo", :on => :collection
  get "profile", :on => :collection
  post "profile", :on => :collection
  get "ssc", :on => :collection
  post "ssc", :on => :collection
  get "new_info", :on => :collection
  post "new_info", :on => :collection
  get "new_addr_info", :on => :collection
  post "new_addr_info", :on => :collection
  get "new_ssc", :on => :collection
  post "new_ssc", :on => :collection
  get "page2", :on => :collection
  get "page3", :on => :collection
  get "page4", :on => :collection
  get "page5", :on => :collection
  post "page2", :on => :collection
  post "page3", :on => :collection
  post "page4", :on => :collection
  post "page5", :on => :collection
  get "show", :on => :collection
  get "welcome_setup", :on => :collection
  get "welcome_ssc", :on => :collection
  get "commit_to_memory", :on => :collection
  get "caution", :on => :collection
end

 resources :form_wizard
 
 resources :login do
  get "page1", :on => :collection
  get "page2", :on => :collection
  get "page3", :on => :collection
  get "view", :on => :collection
  get "forgot_pass", :on => :collection
  get "forgot_pass2", :on => :collection
  get "welcome_login", :on => :collection
  get "sendNewCT", :on => :collection
  get "checkSSC", :on => :collection
  get "checkBoxCode", :on => :collection
  get "checkCT", :on => :collection
  post "page1", :on => :collection
  post "page2", :on => :collection
  post "page3", :on => :collection
  post "view", :on => :collection
  post "forgot_pass", :on => :collection
  post "forgot_pass2", :on => :collection
  put "page1", :on => :collection
  put "page2", :on => :collection
  put "page3", :on => :collection
  put "view", :on => :collection
end
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
