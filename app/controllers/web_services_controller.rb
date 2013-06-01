class WebServicesController < ApplicationController
  
  def show
    return render(:template => 'articles/missing') unless WebService.exists? params[:id]
    
    @article = WebService.find(params[:id])

    # refuse to display unpublished articles
    return render(:template => 'articles/missing') unless @article.published?

    #redirection of old permalinks
    if request.path != web_service_path( @article )
      logger.info "Old permalink: #{request.path}"
      return redirect_to @article, status: :moved_permanently
    end

    # basic statistics on how many times an article has been accessed
    @article.delay.increment! :access_count
    @article.delay.category.increment!(:access_count) if @article.category

  # handle old html articles
    unless @article.render_markdown
      @content_html = @article.content
      render :show_html and return
    end

    @content_main =  @article.md_to_html( :content_main )
    @content_main_extra = @article.md_to_html( :content_main_extra )
    @content_need_to_know =  @article.md_to_html( :content_need_to_know )


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end    
  end	

  def preview
    @article = WebService.new(session[:article_preview])
    authorize! :preview, @article

    @content_main =  @article.md_to_html( :content_main )
    @content_main_extra = @article.md_to_html( :content_main_extra )
    @content_need_to_know =  @article.md_to_html( :content_need_to_know )

    @preview = true
    render 'show'
  end

  
end
