class CategoriesController < ApplicationController
  def show
    return render(:template => 'categories/missing') unless Category.exists? params[:id]
    @bodyclass = "results"

    @category = Category.find(params[:id])
    # redirection of old permalinks
    if request.path != category_path(@category)
      logger.info "Old permalink: #{request.path}"
      return redirect_to @category, status: :moved_permanently
    end

    @category.delay.increment! :access_count

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end
end
