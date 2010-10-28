ActionController::Routing::Routes.draw do |map|
  map.resources :notes

  map.resources :credits

  map.resources :list_items

  map.resources :items

  map.connect '/packing_slips/list_items', :controller => :packing_slips, :action => :list_items
  map.resources :packing_slips, :member => {:post_data => :post}

  map.resources :carriers


  map.resources :team_members do |team_members|
    team_members.resources :shipments
  end

  map.resources :contacts, :member => {:post_data => :post}

  map.bol_upload '/bol_upload/:id', :controller => :shipments, :action => :bol_upload

  map.pending_shipments '/shipments/pending', :controller => :shipments, :action => :pending
  map.delivered_shipments '/shipments/delivered', :controller => :shipments, :action => :delivered
  map.invoiced_shipments '/shipments/invoiced', :controller => :shipments, :action => :invoiced
  map.resources :shipments, :member => {:deliver => :get, :invoice => :get, :credit => :get, :credit_applied => :get, :pending_post_data => :post, :delivered_post_data => :post, :invoiced_post_data => :post} do |shipments|
    shipments.resources :notes
  end

  map.create_from_packing_slip '/shipments/create_from_packing_slip/:id', :controller => :shipments, :action => :create_from_packing_slip

  map.resources :password_resets

  map.signup 'signup', :controller => 'users', :action => 'new'

  map.resources :users

  map.resource :account, :controller => 'users'

  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  map.login 'login', :controller => 'user_sessions', :action => 'new'

  map.resource :user_session

  map.root :controller => :user_sessions, :action => :new

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
