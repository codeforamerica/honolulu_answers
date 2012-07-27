class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json

  # caches_page :index

  def index
    @bodyclass = "results"
  
    @categories = Rails.cache.fetch('category_by_access_count') do
      Category.all_by_access_count
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    return render(:template => 'articles/missing') unless Article.exists? params[:id]

    @article = Article.find(params[:id])
    # redirection of old permalinks
    if request.path != article_path( @article )
      logger.info "Old permalink: #{request.path}"
      return redirect_to @article, status: :moved_permanently
    end

    @article.delay.increment! :access_count
    @article.delay.category.increment!(:access_count) if @article.category   



    @content_html = BlueCloth.new(@article.content).to_html
    @bodyclass = "results"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end    
  end
  
  
  #Going to be created for missing articles - Joey

  # If you like you can put this in the show method: (Phil)
=begin    
          if Article.find(params[:id])
            render the article
          else
            render the missing article page
          end     
=end      
  def missing
    if :id > 15
      render :layout => 'missing'
    end
  end

end
