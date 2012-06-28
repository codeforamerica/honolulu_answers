class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    @bodyclass = "results"
  
    @articles = Article.all

    @articles_hash = {}
    @articles.each do |article|
      article.category = "Uncategorized" if article.category == nil
      if @articles_hash[article.category]
        @articles_hash[article.category] << article
      else
        @articles_hash[article.category] = [article]
      end
    end

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
      @content_html = BlueCloth.new(@article.content).to_html
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @article }
      end      
    rescue
      render :template => 'articles/missing'
    end
    
    if @article.nil?
    end
    puts "Working this far"
    
  

  end
  
  #Going to be created for missing articles - Joey
  def missing
    if :id > 15
      render :layout => 'missing'
    end
  end

end
