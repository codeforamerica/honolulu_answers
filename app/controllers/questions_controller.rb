class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(
      :question => params[:question],
      :name     => params[:name],
      :email    => params[:email],
      :context  => params[:context],
      :location => params[:location],
      :urgency  => params[:urgency]
    )
  end
end
