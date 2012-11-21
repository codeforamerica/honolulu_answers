class GuidesController < ApplicationController
	# caches_page :show
	def show
		return render(:template => 'articles/missing') unless Guide.exists? params[:id]

		@article = Guide.find(params[:id])

		return render(:template => 'articles/missing') unless @article.published?
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
    	#content = @article.render_markdown ? @article.content_md : @article.content
	    #@content_html = BlueCloth.new(content).to_html

        # Add support for quick-top in markdown

   		@content_main =  @article.md_to_html( @article.content )
   		@article.guide_steps.each do |step|
   		  step.content = @article.md_to_html( step.content )
   		end

	    respond_to do |format|
	      format.html # show.html.erb
	      format.json { render json: @article }
	    end 
  end
end
