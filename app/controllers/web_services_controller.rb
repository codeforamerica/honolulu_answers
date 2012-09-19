class WebServicesController < ApplicationController
  caches_page :show
  
  def show
    return render(:template => 'articles/missing') unless WebService.exists? params[:id]
    
    @article = WebService.find(params[:id])

    return render(:template => 'articles/missing') unless @article.is_published
    #redirection of old permalinks
    if request.path != web_service_path( @article )
      logger.info "Old permalink: #{request.path}"
      return redirect_to @article, status: :moved_permanently
    end

    @article.delay.increment! :access_count
    @article.delay.category.increment!(:access_count) if @article.category   

    @content_html = BlueCloth.new(@article.content).to_html
    @bodyclass = "results"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end    
  end	
end
