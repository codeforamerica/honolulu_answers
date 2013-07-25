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

    if QuestionMailer.submitted_question(@question).deliver
      flash[:success] = "Thanks for submitting a question! We'll review it and try to answer it as best as we can."
    else
      flash[:success] = "I'm sorry but your question couldn't be sent.  Please contact #{ENV['CONTACT_EMAIL']}"
    end

    redirect_to :root
  end
end
