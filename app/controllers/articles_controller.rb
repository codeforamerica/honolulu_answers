class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json

  # caches_page :show # TODO: make the cache expire when an article is updated.  Currently can't get the cache to clear properly.

  def index
    @bodyclass = "results"
  
    @categories = Rails.cache.fetch('category_by_access_count') do
      Category.all_by_access_count
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
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
  

  def article_type
    @article_type = params[:content_type]

    # convert paramaterized url
    @articles = Article.find_by_type(@article_type)
    @article_type = @article_type.gsub(/-/, ' ').titlecase
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
  #TODO can we just delete this now?
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
