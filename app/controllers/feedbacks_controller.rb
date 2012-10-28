class FeedbacksController < ApplicationController
  before_filter :find_artilce_of_feedback

  def create
    receive_feedback
    update_feedback
  end

  def update
    receive_feedback
    update_feedback
  end

  private
    def find_artilce_of_feedback
      @article = Article.find(params[:quick_answer_id])
    end

    def receive_feedback
      @feedback = @article.feedback
      if params[:yes_feedback] == "Like"
        @feedback.yes_feedback
      elsif params[:no_feedback] == "Dislike"
        @feedback.no_feedback
      end
    end

    def update_feedback
      if @feedback.save
        flash[:notice] = "Thanks for your feedback."
      end
      redirect_to quick_answer_path(@article)
    end

end
