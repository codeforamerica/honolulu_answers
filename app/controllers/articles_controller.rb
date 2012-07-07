class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    @bodyclass = "results"
  
    @categories = Category.all_by_access_count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    begin
      @bodyclass = "results"
      @article = Article.find(params[:id])

      @article.increment! :access_count
      @article.category.increment!(:access_count) id @article.category

      # redirection of old permalinks
      if request.path != article_path( @article )
        logger.info "Old permalink: #{request.path}"
        return redirect_to @article, status: :moved_permanently
      end

      @content_html = BlueCloth.new(@article.content).to_html
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @article }
      end      
    rescue
      render :template => 'articles/missing'
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
