class QuickAnswersController < ApplicationController

  def show
    return render(:template => 'articles/missing') unless QuickAnswer.exists? params[:id]

    @article = QuickAnswer.find(params[:id])
    authorize! :read, @article

    @feedback = @article.feedback
    if @feedback.nil?
      @feedback = @article.create_feedback!
    end

    #redirection of old permalinks
    if request.path != quick_answer_path( @article )
      logger.info "Old permalink: #{request.path}"
      return redirect_to @article, :status => :moved_permanently
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
    @article = QuickAnswer.new session[:article_preview]
    authorize! :preview, @article

    @feedback = @article.feedback
    if @feedback.nil?
      @feedback = @article.create_feedback!
    end

    @content_main =  @article.md_to_html( :content_main )
    @content_main_extra = @article.md_to_html( :content_main_extra )
    @content_need_to_know =  @article.md_to_html( :content_need_to_know )

    @preview = true
    render 'show'
  end
end
