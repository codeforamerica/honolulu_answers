class GuidesController < ApplicationController
	caches_page :show
	def show
		return render(:template => 'articles/missing') unless Guide.exists? params[:id]
		@guide = Guide.find(params[:id])

	    respond_to do |format|
	      format.html # show.html.erb
	      #format.json { render json: @guide }
	    end
  end
end