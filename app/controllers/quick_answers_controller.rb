class QuickAnswersController < ApplicationController

  caches_page :show

  def show
    return render(:template => 'articles/missing') unless QuickAnswer.exists? params[:id]
    
    @article = QuickAnswer.find(params[:id])
    #redirection of old permalinks
    if request.path != quick_answer_path( @article )
      logger.info "Old permalink: #{request.path}"
      return redirect_to @article, status: :moved_permanently
    end

    @article.delay.increment! :access_count
    @article.delay.category.increment!(:access_count) if @article.category   

    # @content_html = BlueCloth.new(@article.content).to_html
    @content_html = @article.content
    @bodyclass = "results"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end    
  end
end
