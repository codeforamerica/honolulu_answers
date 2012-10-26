class GuidesController < ApplicationController
	caches_page :show
	def show
		@article = Guide.find(params[:id])

		return render(:template => 'articles/missing') unless @article.is_published
	    #redirection of old permalinks
	    if request.path != guide_path( @article )
	      logger.info "Old permalink: #{request.path}"
	      return redirect_to @article, status: :moved_permanently
	    end

	    @article.delay.increment! :access_count
	    @article.delay.category.increment!(:access_count) if @article.category   

        content = @article.render_markdown ? @article.content_md : @article.content
	    @content_html = BlueCloth.new(content).to_html

        # Add support for quick-top in markdown
        hr = /<hr( \/)?>/
          if @content_html.match hr
            @content_html.gsub!(hr,"</div>")
            @content_html = "<div class='quick_top'>" + @content_html
          end

	    respond_to do |format|
	      format.html # show.html.erb
	      format.json { render json: @article }
	    end 
  end
end
