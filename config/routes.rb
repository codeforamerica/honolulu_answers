Honoluluanswers::Application.routes.draw do
  get "quick_answer/show"

  # devise_for :admin_users, ActiveAdmin::Devise.config

  get "category/index"

  ActiveAdmin.routes(self)

  #devise_for :administrators

  devise_for :users, :controllers => { :sessions => "sessions" }

  resources :contacts

  resources :articles

  resources :categories

  resources :guides

  resources :web_services do
    member do
      get 'preview'
    end
  end

  resources :quick_answers do
    member do
      get 'preview'
    end
  end

  #get "home/index"
  root :to => "home#index"

  match '/about' => "home#about" , :as => :about
  match '/search/' => "search#index" , :as => :search, :via => [:get, :post] 
  match 'autocomplete' => "search#autocomplete"
  match '/articles/article-type/:content_type' => "articles#article_type"

  match '/search/spell_check' => 'search#spell_check', :as => :spell_check, :via => :get

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
  # match ':controller(/:action(/:id))(.:format)'
end
