class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def create
    submitted = params[:question]

    @question = Question.create(
      :question => submitted[:question],
      :context  => submitted[:context],
      :urgency  => submitted[:urgency],
      :name     => submitted[:name],
      :email    => submitted[:email],
      :location => submitted[:location]
    )

    flash[:success] = "Thanks for submitting a question! We'll review it and try to answer it as best as we can."
    QuestionMailer.submitted_question(@question).deliver

    redirect_to :root
  end
end
