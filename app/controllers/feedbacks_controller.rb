class FeedbacksController < ApplicationController
  before_filter :find_article_of_feedback

  def create
    receive_feedback
    update_feedback
  end

  def update
    receive_feedback
    update_feedback
  end

  private
    def find_article_of_feedback
      if params[:quick_answer_id]
        @article = Article.find(params[:quick_answer_id])
      elsif params[:web_service_id]
        @article = Article.find(params[:web_service_id])
      end
    end

    def receive_feedback
      @feedback = @article.feedback
      if params[:yes_feedback] == "yes"
        @feedback.yes_feedback
      elsif params[:no_feedback] == "no"
        @feedback.no_feedback
      end
    end

    def update_feedback
      if @feedback.save
        flash[:success] = "Thanks for your feedback."
      end
      redirect_to article_path(@article)
    end

end
