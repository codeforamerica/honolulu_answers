Honoluluanswers::Application.routes.draw do
  root :to => "home#index"

  # Content management
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :sessions => "sessions" }

  match '/about' => "home#about" , :as => :about
  match '/search/' => "search#index" , :as => :search, :via => [:get, :post]

  resources :contacts
  resources :categories

  # Articles
  resources :articles # legacy, redirects to the appropriate specific resource
  resources :quick_answers
  resources :web_services
  resources :guides
  match '/articles/article-type/:content_type' => "articles#article_type"
end
