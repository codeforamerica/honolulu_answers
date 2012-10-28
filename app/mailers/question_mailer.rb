class QuestionMailer < ActionMailer::Base
  default from: "feedback@wmgreenguide.com"

  def submitted_question(question)
    @question = Question.find(question.id)
    mail(:to => 'contact@wmgreenguide.com', :subject => "[WMGG] New question by #{question.name}")
  end
end
