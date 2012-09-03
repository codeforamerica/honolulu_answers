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

    time_to_run = Time.new(Date.tomorrow.year, Date.tomorrow.month, Date.tomorrow.day, 02, 00)
    @article.delay(:run_at => time_to_run).increment! :access_count
    @article.delay(:run_at => time_to_run).category.increment!(:access_count) if @article.category   

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
    @article_type = @article_type.gsub(/-/, ' ').titlecase

    @articles = Article.find_by_type(@article_type)
  end

  #TODO can we just delete this now?
  def missing
    if :id > 15
      render :layout => 'missing'
    end
  end

end
