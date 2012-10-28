Honoluluanswers::Application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :users

  resources :contacts, :articles, :categories, :guides, :resources, :quick_answers

  get "quick_answer/show"
  get "category/index"

  resources :questions, :via => [:get, :post] do
    collection do
      get 'working'
      get 'answered'
    end
  end

  resources :quick_answers do
    resources :feedbacks
  end

  root :to => "home#index"

  match '/about' => "home#about" , :as => :about
  match '/search/' => "search#index" , :as => :search, :via => [:get, :post]
  match 'autocomplete' => "search#autocomplete"
  match '/articles/article-type/:content_type' => "articles#article_type"

end
