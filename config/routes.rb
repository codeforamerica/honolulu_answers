Honoluluanswers::Application.routes.draw do
  root :to => "home#index"

  # Content management
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :sessions => "sessions" }

  match '/about' => "home#about" , :as => :about
  match '/search/' => "search#index" , :as => :search, :via => [:get, :post]

  resources :categories, :only => :show

  # legacy, redirects to the appropriate specific resource
  resources :articles, :only => [:show, :article_type]

  resources :quick_answers, :only => :show
  resources :web_services, :only => :show
  resources :guides, :only => :show
  match '/articles/article-type/:content_type' => "articles#article_type"

  match "/admin/markdown-cheatsheet" => "admin/articles#download_markdown_cheatsheet", :as => "markdown_cheatsheet"
end
