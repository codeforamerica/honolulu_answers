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

    unless @article.render_markdown
      @content_html = @article.content
        hr = /<hr( \/)?>/
        if @content_html.match hr
          @content_html.gsub!(hr,"</div>")
          @content_html = "<div class='quick_top'>" + @content_html
        end
      render :show_html and return
    end

    @content_main = @article.md_to_html(@article.content)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end
end
