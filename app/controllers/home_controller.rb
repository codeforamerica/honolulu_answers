class HomeController < ApplicationController

  caches_page :index

  def index
    @popular_categories = Category.by_access_count.limit(3)
  end

 def about
 end

end
