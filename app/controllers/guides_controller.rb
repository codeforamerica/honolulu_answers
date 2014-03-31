class GuidesController < ApplicationController
  def show
    return render(:template => 'articles/missing') unless Guide.exists? params[:id]

    @article = Guide.find(params[:id])

    authorize! :read, @article
    #redirection of old permalinks
    if request.path != guide_path( @article )
      logger.info "Old permalink: #{request.path}"
      return redirect_to @article, status: :moved_permanently
    end

    @article.delay.increment! :access_count
    @article.delay.category.increment!(:access_count) if @article.category

    unless @article.published?
      flash.now[:info] = "This article has not been published."
    end


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end
end
