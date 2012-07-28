class CategoriesController < ApplicationController
  def index
  	@bodyclass = "results"
  
    @categories = Rails.cache.fetch('category_by_access_count') do
      Category.all_by_access_count
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end
  def show
  	return render(:template => 'categories/missing') unless Category.exists? params[:id]

    @category = Category.find(params[:id])
    # redirection of old permalinks
    if request.path != category_path( @category )
      logger.info "Old permalink: #{request.path}"
      return redirect_to @category, status: :moved_permanently
    end

    @category.delay.increment! :access_count
 
    @content_html = BlueCloth.new(@category.name).to_html
    @bodyclass = "results"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  def missing
    render :layout => 'missing'
  end
end
